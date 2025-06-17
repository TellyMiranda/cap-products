namespace com.logali;

using {cuid,
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

type Dec  : Decimal(16, 2);

context Materials {

    entity Products : cuid {
        Name                 : String not null;
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
        Supplier             : Association to sales.Suppliers;
        UnitOfMesasures_ID   : String(2);
        ToUnitOfMesasures_ID : Association to UnitOfMesasures;
        Currency             : Association to Currencies;
        DimensionUnits       : Association to DimensionUnits;
        Category             : Association to Categories;
        SalesData            : Association to many sales.SalesData
                                   on SalesData.Product = $self;
        Reviews              : Association to many ProductReview
                                   on Reviews.Product = $self;
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

    entity ProductReview : cuid {
        // key ID      : UUID;
        Name    : String;
        Rating  : Integer;
        Comment : String;
        Product : Association to Products;
    };

}

entity SelProducts   as select from Materials.Products;
entity ProjProducts  as projection on Materials.Products;

entity ProjProducts2 as
    projection on Materials.Products {
        *
    };

entity ProjProducts3 as
    projection on Materials.Products {
        ReleaseDate,
        Name
    };

// extend Products with {
//     PriceCondition     : String(2);
//     PriceDetermination : String(3);
// };

context sales {
    entity Orders : cuid {
        Date     : Date;
        Customer : String;
        Item     : Composition of many OrdersItems
                       on Item.Order = $self;
    };

    entity Suppliers : cuid {
        Name    : type of Materials.Products : Name;
        Address : Address;
        Email   : String;
        Phone   : String;
        Fax     : String;
        Product : Association to many Materials.Products
                      on Product.Supplier = $self;
    };


    entity Months {
        key ID               : String(2);
            Description      : localized String;
            ShortDescription : localized String(3);
    };

    entity SelProducts1 as
        select from Materials.Products {
            *
        };

    entity SelProducts2 as
        select from Materials.Products {
            Name,
            Price,
            Quantity

        };

    entity SelProducts3 as
        select from Materials.Products
        left join Materials.ProductReview
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

    entity SalesData : cuid {
        DeliveryDate  : DateTime;
        Revenue       : Decimal(16, 2);
        Product       : Association to Materials.Products;
        Currency      : Association to Materials.Currencies;
        DeliveryMonth : Association to sales.Months;
    };

    entity OrdersItems : cuid {
        Order    : Association to sales.Orders;
        Product  : Association to Materials.Products;
        Quantity : Integer;
    };
}
