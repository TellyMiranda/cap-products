sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"logaligroup/product/test/integration/pages/ProductsList",
	"logaligroup/product/test/integration/pages/ProductsObjectPage"
], function (JourneyRunner, ProductsList, ProductsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('logaligroup/product') + '/index.html',
        pages: {
			onTheProductsList: ProductsList,
			onTheProductsObjectPage: ProductsObjectPage
        },
        async: true
    });

    return runner;
});

