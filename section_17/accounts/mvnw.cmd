Step to work with auditing:

1. create Bean by implementing AuditorAware interface

@Component("auditAwareImpl")
//here in AuditorAware<String>, this String is the DataType of "createdBy" field of "BaseEntity" class attribute.
public class AuditAwareImpl implements AuditorAware<String> {

    /**
     * Returns the current auditor of the application.
     *
     * @return the current auditor.
     */
    @Override
    public Optional<String> getCurrentAuditor() {
        //this data is inserted in createdBy and updatedBy filed in db.
        return Optional.of("ACCOUNTS_MS");
    }

}

2. create enable auditing in main class:

@EnableJpaAuditing(auditorAwareRef = "auditAwareImpl")
public class AccountsApplication {

	public static void main(String[] args) {
		SpringApplication.run(AccountsApplication.class, args);
	}

}

3. create BaseEntity class and define all four attribute.

@EntityListeners(AuditingEntityListener.class)
@Getter @Setter @ToString
public class BaseEntity {

    @CreatedDate
    @Column(updatable = false) //only allow to insert not update
    private LocalDateTime createdAt;

    @CreatedBy
    @Column(updatable = false) //only allow to insert not update
    private String createdBy;

    @LastModifiedDate
    @Column(insertable = false) //only allow to update not insert
    private LocalDateTime updatedAt;

    @LastModifiedBy
    @Column(insertable = false) //only allow to update not insert
    private String updatedBy;
}

