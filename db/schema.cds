namespace com.logali;

using {
    cuid,
    //managed
} from '@sap/cds/common';

type Name : String(50);

type Address {
    Street     : String;
    City       : String;
    State      : String(2);
    PostalCode : String(5);
    Country    : String(3);
};

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

type Dec : Decimal(16, 2);

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

entity Products : cuid {
    Name                 : localized String not null;
    Description          : localized String;
    ImageURL             : String;
    ReleaseDate          : DateTime default $now;
    DiscontinuedDate     : DateTime;
    Price                : Dec;
    Height               : type of Price; //Decimal(16, 2)
    Width                : Decimal(16, 2);
    Depth                : Decimal(16, 2);
    Quantity             : Decimal(16, 2);
    Suppliers_Id         : UUID;
    Supplier             : Association to Suppliers;
    UnitOfMesasures_ID   : String(2);
    ToUnitOfMesasures_ID : Association to UnitOfMesasures;
    Currency             : Association to Currencies;
    DimensionUnits       : Association to DimensionUnits;
    Category             : Association to Categories;
    SalesData            : Association to many SalesData
                               on SalesData.Product = $self;
    Reviews              : Association to many ProductReview
                               on Reviews.Product = $self;
};

entity Orders : cuid {
    Date     : Date;
    Customer : String;
    Item     : Composition of many OrdersItems
                   on Item.Order = $self;
};

entity OrdersItems : cuid {
    Order    : Association to Orders;
    Product  : Association to Products;
    Quantity : Integer;
};

entity Suppliers : cuid {
    Name    : type of Products : Name;
    Address : Address;
    Email   : String;
    Phone   : String;
    Fax     : String;
    Product : Association to many Products
                  on Product.Supplier = $self;
};

entity Categories {
    key ID   : String(1);
        name : localized String;
};

entity StockAvailability {
    key ID          : String(1);
        Description : localized String;
        Product     : Association to Products;
};

entity Currencies {
    key ID          : String(3);
        Description : localized String;
};

entity UnitOfMesasures {
    key ID          : String(2);
        Description : localized String;
};

entity DimensionUnits {
    key ID          : String(2);
        Description : localized String;
};

entity Months {
    key ID               : String(2);
        Description      : localized String;
        ShortDescription : localized String(3);
};

entity ProductReview : cuid {
    // key ID      : UUID;
    Name    : String;
    Rating  : Integer;
    Comment : String;
    Product : Association to Products;
};

entity SalesData : cuid {
    DeliveryDate  : DateTime;
    Revenue       : Decimal(16, 2);
    Product       : Association to Products;
    Currency      : Association to Currencies;
    DeliveryMonth : Association to Months;
};

entity SelProducts3 as
    select from Products
    left join ProductReview
        on Products.Name = ProductReview.Name
    {
        Rating,
        Products.Name,
        sum(Price) as TotalPrice
    }
    group by
        Rating,
        Products.Name
    order by
        Rating;

entity ProjProducts as projection on Products;

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

extend Products with {
    PriceCondition     : String(2);
    PriceDetermination : String(3);
};

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
