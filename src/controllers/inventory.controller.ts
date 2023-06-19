import express from "express";
const app = express.Router();
import Inventory from "../services/inventory.services";
import Notification from "../services/notification.services";
import User from "../services/user.services";

app.get("/", async (req, res) => {
    const inventories = await Inventory.get();

    return res.status(200).json({
        status: 200,
        message: "Inventories Retrieved Successfully!",
        data: inventories,
    });
});

app.get("/:id", async (req, res) => {
    const { id } = req.params;

    const inventory = await Inventory.getById(Number(id));

    if (inventory) {
        return res.status(200).json({
            status: 200,
            message: "Inventory Retrieved Successfully!",
            data: inventory,
        });
    } else {
        return res.status(404).json({
            status: 404,
            message: `Inventory with id ${id} don't exist`,
        });
    }
});

app.get("/vendor/:id", async (req, res) => {
    const { id } = req.params;

    const inventory = await Inventory.getByVendorId(Number(id));

    if (inventory) {
        return res.status(200).json({
            status: 200,
            message: "Vendor's Inventory Retrieved Successfully!",
            data: inventory,
        });
    } else {
        return res.status(404).json({
            status: 404,
            message: `Inventory with id ${id} don't exist`,
        });
    }
});

app.post("/", async (req, res) => {
    const { name, category, stock, vendor_id, discount, price } = req.body;

    if (!name) return res.status(400).json({ message: 'name is required' });

    if (!category) return res.status(400).json({ message: 'category is required' });

    if (!stock) return res.status(400).json({ message: 'stock is required' });

    if (!vendor_id) return res.status(400).json({ message: 'vendor_id is required' });

    if (!price) return res.status(400).json({ message: 'price is required' });

    const inventory = await Inventory.create({
        name,
        category,
        stock,
        vendor_id,
        discount: discount ? Number(discount) : null,
        price: Number(price)
    });

    if (inventory) {

        const vendor = await User.getById(vendor_id);

        await Notification.create({
            message: `New ${inventory.name} added by ${vendor.name}`,
            inventory_id: inventory.id,
        });

        return res.status(201).json({
            status: 201,
            message: "Successfully created inventory record!",
            data: inventory,
        });

    } else {

        return res.status(500).json({
            status: 500,
            message: "Failed to create inventory record!",
        });

    }

});

app.put("/:id", async (req, res) => {
    const { id } = req.params;

    const data = req.body;

    const inventory = await Inventory.update(data, Number(id));

    if (inventory) {

        return res.status(200).json({
            status: 200,
            message: "Successfully update inventory record!",
            data: inventory,
        });

    } else {

        return res.status(500).json({
            status: 500,
            message: "Failed to update inventory record!",
        });

    }

});

app.delete("/:id", async (req, res) => {
    const { id } = req.params;

    const inventory = await Inventory.delete(Number(id));

    if (inventory) {

        return res.status(200).json({
            status: 200,
            message: "Successfully deleted inventory record!",
            data: inventory,
        });

    } else {

        return res.status(500).json({
            status: 500,
            message: "Failed to delete inventory record!",
        });

    }

});

export default app;
