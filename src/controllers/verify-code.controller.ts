import express from "express";
const app = express.Router();
import Rescue from "../services/rescue.services";
import RescueInventory from "../services/rescue.inventory.services";
import Inventory from "../services/inventory.services";

app.post("/", async (req, res) => {
    const { rescue_id, code } = req.body;

    if (!rescue_id) return res.status(400).json({ message: 'rescue_id is required' });

    if (!code) return res.status(400).json({ message: 'code is required' });

    const rescue = await Rescue.getById(Number(rescue_id));

    if (rescue.code === code && rescue.status === "PENDING") {

        let rescueStatus = "";

        const rescueInventory = await RescueInventory.getByRescueId(rescue.id);

        if (!rescueInventory) {

            rescueStatus = "CANCELED";

            await Rescue.update({
                status: rescueStatus
            }, rescue.id);

            return res.status(404).json({
                status: 404,
                message: `Rescue with id ${rescue_id} is cancelled, due to not having rescue inventory`,
            });

        }

        const inventoryStock = await Inventory.getSingleById(rescueInventory.inventory_id);

        const difference = inventoryStock.stock - rescueInventory.quantity;

        let inventory;

        if (difference >= 0) {

            inventory = await Inventory.updateStock(rescueInventory.quantity, rescueInventory.inventory_id);

            rescueStatus = "COMPLETED";

        } else {

            rescueStatus = "CANCELED";

            return res.status(200).json({
                status: 200,
                message: `Rescue with id ${rescue_id}, not enough stock level`,
            });

        }

        const updatedRescue = await Rescue.update({
                status: rescueStatus
        }, rescue.id);

        delete updatedRescue.Vendor?.password;

        return res.status(200).json({
            status: 200,
            message: "Successfully updated stock",
            data: updatedRescue,
        });

    } else if (rescue.status === "COMPLETED") {

        return res.status(200).json({
            status: 200,
            message: `Rescue with id ${rescue_id} is and code ${code} already claimed!`,
        });

    } else {

        return res.status(404).json({
            status: 404,
            message: `Rescue with id ${rescue_id} don't exists OR invalid code`,
        });

    }

});

export default app;
