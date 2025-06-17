namespace com.training;


entity course {
    key ID      : UUID;
        Student : Association to many StudentCourse
                      on Student.Course = $self;
}

entity Student : cuid {
    Course : Association to many StudentCourse
                 on Course.Student = $self;
}

entity StudentCourse : cuid {
    Student : Association to Student;
    Course  : Association to course;
}


// type Gender : String enum {
//     male;
//     female;
// };

// entity Order {
//     ClientGender : Gender;
//     Status       : Integer enum {
//         submitted = 1;
//         fulfiller = 2;
//         shipped = 3;
//         cancel = -1;
//     };
//     priority     : String @assert.range enum {
//         height;
//         medium;
//         low;
//     }
// };
// entity Car {
//     key     ID        : UUID;
//             name      : String;
//     virtual dicount_1 : Decimal;
//     virtual dicount_2 : Decimal;
// }
// type EmailsAddresses_01 : many {
//     kind  : String;
//     email : String;
// };

// type EmailsAddresses_02 : {
//     kind  : String;
//     email : String;
// };

// entity Emails {
//     email_01 : EmailsAddresses_01;
//     email_02 : many EmailsAddresses_02;
//     email_03 : many {
//         kind  : String;
//         email : String;
//     }
// };

// entity ProjProducts2 as
//     projection on Products {
//         *
//     };

// entity ProjProducts3 as
//     projection on Products {
//         ReleaseDate,
//         Name
//     };


// entity ParamProducts(pName : String)     as
//     select from Products {
//         Name,
//         Price,
//         Quantity
//     }
//     where
//         Name = :pName;

// entity ProjParamProducts(pName : String) as projection on Products
//                                             where
//                                                 Name = :pName;
