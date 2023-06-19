import express from "express";
const app = express.Router();
import RescueInventory from "../services/rescue.inventory.services";

app.get("/", async (req, res) => {
    const rescueInventories = await RescueInventory.get();

    return res.status(200).json({
        status: 200,
        message: "Rescue Inventories Retrieved Successfully!",
        data: rescueInventories,
    });
});

app.get("/:id", async (req, res) => {
    const { id } = req.params;

    const rescueInventory  = await RescueInventory.getById(Number(id));

    if (rescueInventory) {
        return res.status(200).json({
            status: 200,
            message: "RescueInventory Retrieved Successfully!",
            data: rescueInventory,
        });
    } else {
        return res.status(404).json({
            status: 404,
            message: `RescueInventory with id ${id} don't exist`,
        });
    }
});

app.get("/rescue/:id", async (req, res) => {
    const { id } = req.params;

    const rescueInventory  = await RescueInventory.getByAllRescueId(Number(id));

    if (rescueInventory) {
        return res.status(200).json({
            status: 200,
            message: "RescueInventory Retrieved Successfully!",
            data: rescueInventory,
        });
    } else {
        return res.status(404).json({
            status: 404,
            message: `RescueInventory with id ${id} don't exist`,
        });
    }
});

app.get("/vendor/:id", async (req, res) => {
    const { id } = req.params;

    const rescueInventory = await RescueInventory.getByVendorId(Number(id));

    if (rescueInventory) {
        return res.status(200).json({
            status: 200,
            message: "Vendor Rescue Inventory Retrieved Successfully!",
            data: rescueInventory,
        });
    } else {
        return res.status(404).json({
            status: 404,
            message: `Vendor Rescue Inventory with id ${id} don't exist`,
        });
    }
});

app.get("/fii/:id", async (req, res) => {
    const { id } = req.params;

    const rescueInventory  = await RescueInventory.getByFiiId(Number(id));

    if (rescueInventory) {
        return res.status(200).json({
            status: 200,
            message: "Fii Rescue Inventory Retrieved Successfully!",
            data: rescueInventory,
        });
    } else {
        return res.status(404).json({
            status: 404,
            message: `Fii Rescue Inventory with id ${id} don't exist`,
        });
    }
});

app.post("/", async (req, res) => {
    const { rescue_id, inventory_id, quantity } = req.body;

    if (!rescue_id) return res.status(400).json({ message: 'rescue_id is required' });

    if (!quantity) return res.status(400).json({ message: 'quantity is required' });

    if (!inventory_id) return res.status(400).json({ message: 'inventory_id is required' });


    const rescueInventory = await RescueInventory.create({
        quantity,
        inventory_id,
        rescue_id,
    });

    if (rescueInventory) {
        return res.status(201).json({
            status: 201,
            message: "Successfully created RescueInventory record!",
            data: rescueInventory,
        });
    } else {
        return res.status(500).json({
            status: 500,
            message: "Failed to create RescueInventory record!",
        });
    }
});

app.put("/:id", async (req, res) => {
    const { id } = req.params;

    const data = req.body;

    const rescueInventory = await RescueInventory.update(data, Number(id));

    if (rescueInventory) {
        return res.status(200).json({
            status: 200,
            message: "Successfully update RescueInventory record!",
            data: rescueInventory,
        });
    } else {
        return res.status(500).json({
            status: 500,
            message: "Failed to update RescueInventory record!",
        });
    }
});

app.delete("/:id", async (req, res) => {
    const { id } = req.params;

    const rescueInventory = await RescueInventory.delete(Number(id));

    if (rescueInventory) {
        return res.status(200).json({
            status: 200,
            message: "Successfully deleted RescueInventory record!",
            data: rescueInventory,
        });
    } else {
        return res.status(500).json({
            status: 500,
            message: "Failed to delete RescueInventory record!",
        });
    }
});

export default app;
