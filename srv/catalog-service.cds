using {com.logali as logali} from '../db/schema';

service CatalogService {
    entity Products        as projection on logali.Products;
    entity Suppliers       as projection on logali.Suppliers;
    entity Currency        as projection on logali.Currencies;
    entity DimensionUnits  as projection on logali.DimensionUnits;
    entity Category        as projection on logali.Categories;
    entity SalesDatas      as projection on logali.SalesData;
    entity Reviews         as projection on logali.UnitOfMesasures;
    entity UnitOfMesasures as projection on logali.ProductReview;
    entity Months          as projection on logali.Months;
    entity Order           as projection on logali.Orders;
    entity OrdersItem      as projection on logali.OrdersItems;
}
