package com.eazybytes.accounts.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter @Setter @ToString @AllArgsConstructor @NoArgsConstructor
//don't use @data on entity level, because internally it s generate hashcode and equals()
//which cause issue sometime in spring data jpa.
public class Accounts extends  BaseEntity {

    @Column(name="customer_id")
    private Long customerId;

    @Column(name="account_number")
    @Id
    private Long accountNumber;

    @Column(name="account_type")
    private String accountType;

    @Column(name="branch_address")
    private String branchAddress;

    @Column(name = "communication_sw")
    private Boolean communicationSw;

}
