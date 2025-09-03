const { error } = require("@sap/cds");
const cds = require("@sap/cds");
const { message } = require("@sap/cds/lib/log/cds-error");

const { Orders } = cds.entities("com.training");

module.exports = (srv) => {

    srv.before("*",req => {
        console.log(`Method: ${req.method}`);
        console.log(`Target: ${req.target}`);
    });


    //******READ********* */
    srv.on("READ", "Orders", async (req) => {
        if (req.data.ClientEmail !== undefined) {
            return await SELECT.from`com.training.Orders`
                .where`ClientEmail = ${req.data.ClientEmail}`;
        }
        return await SELECT.from(Orders);
    });

    srv.after("READ", "Orders", (data) => {
        return data.map((order) => (order.Reviewed = true));
    });

    //**CREATED *********/
    srv.on("CREATE", "Orders", async (req) => {

        let returnData = await cds.transaction(req)
            .run(
                INSERT.into(Orders).entries({
                    ClientEmail: req.data.ClientEmail,
                    FirstName: req.data.FirstName,
                    LastName: req.data.LastName,
                    CreatedOn: req.data.CreatedOn,
                    Reviewed: req.data.Reviewed,
                    Approved: req.data.Approved,
                })
            )
            .then((resolve, reject) => {
                console.log("Resolve", resolve);
                console.log("Reject", reject);

                if (typeof resolve !== "undefined") {
                    return req.data;
                } else {
                    req.error(409, "Record Not Inserted");
                }
            })
            .catch((err) => {
                console.log(err.code, err.message);
            });

        return returnData;
    });
    srv.before("CREATE", "Orders", (req) => {
        req.data.CreatedOn = new Date().toISOString().slice(0, 10);
        return req;
    });
    //**UPDATE *********/
    srv.on("UPDATE", "Orders", async (req) => {
        let returnData = await cds.transaction(req).run(
            [
                UPDATE(Orders, req.data.ClientEmail).set({
                    FirstName: req.data.FirstName,
                    LastName: req.data.LastName
                })
            ]

        ).then((resolve, reject) => {
            console.log("Resolve: ", resolve);
            console.log("Reject: ", reject);

            if (resolve[0] == 0) {
                req.error(409, "Record Not Found");
            }
        }).catch((err) => {
            console.log(err);
            req.error(err.code, err.message)
        });
        console.log("Before End", returnData);
        return returnData;
    });

    //**DELETE *********/
    srv.on('DeleteOrder',"Orders", async (req) => {
        const { ClientEmail } = req.data;

        try {
            // Ejecuta el DELETE y guarda el número de filas eliminadas
            const deleted = await cds.tx(req).run(
                DELETE.from(Orders).where({ ClientEmail })
            );

            // Si no se borró ninguna fila, devolvemos un 404
            if (deleted === 0) {
                return req.error(404, `Order with ClientEmail '${ClientEmail}' not found`);
            }

            // Devolvemos un resultado claro al cliente
            return { success: true, deletedRows: deleted };

        } catch (err) {
            // En caso de fallo en BD, devolvemos el error correspondiente
            return req.error(err.code || 500, err.message);
        }
    });
    //**FUNCTION*********/
      srv.on('getClientTaxRate', async req => {
    const { clientEmail } = req.data;
    const order = await SELECT.one.from(Orders)
                          .columns('Country_code')
                          .where({ ClientEmail: clientEmail });

    if (!order) {
      return req.error(404, `No existe orden para ${clientEmail}`);
    }

    switch (order.Country_code) {
      case 'ES': return { value: 21.5 };
      case 'UK': return { value: 24.6 };
      default:   return { value: 0.0 };
    }
});
  // ––––– ACTION –––––
  srv.on('cancelOrder', async req => {
    const { clientEmail } = req.data;
    const results = await cds.tx(req).run(
      SELECT.from(Orders,['FirstName','LastName','Approved']).where({ ClientEmail: clientEmail })
    );
    if (!results.length) req.error(404,`No order for ${clientEmail}`);
    const order = results[0];

    const ret = { status:'', message:'' };
    if ( !order.Approved ) {
      await UPDATE(Orders).set({ Status:'C' }).where({ ClientEmail: clientEmail });
      ret.status  = 'Succeeded';
      ret.message = `Orden de ${order.FirstName} ${order.LastName} cancelada.`;
    } else {
      ret.status  = 'Failed';
      ret.message = `No se pudo cancelar (ya aprobada).`;
    }
    return ret;
  });
};
