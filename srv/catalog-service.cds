using com.logali as logali from '../db/schema';
using com.training as training from '../db/training';

service CatalogService {
    entity Products        as projection on logali.Materials.Products;
    entity Suppliers       as projection on logali.sales.Suppliers;
    entity Currency        as projection on logali.Materials.Currencies;
    entity DimensionUnits  as projection on logali.Materials.DimensionUnits;
    entity Category        as projection on logali.Materials.Categories;
    entity SalesDatas      as projection on logali.sales.SalesData;
    entity Reviews         as projection on logali.Materials.ProductReview;
    entity UnitOfMesasures as projection on logali.Materials.UnitOfMesasures;
    entity Months          as projection on logali.sales.Months;
    entity Order           as projection on logali.sales.Orders;
    entity OrdersItem      as projection on logali.sales.OrdersItems;
    //Entidad para referenciar el USING training y evitar Warning
    entity training_aux    as projection on training.course;
}

