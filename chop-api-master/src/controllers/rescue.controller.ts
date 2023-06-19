import express from "express";
const app = express.Router();
import Rescue from "../services/rescue.services";

app.get("/", async (req, res) => {
    const rescues = await Rescue.get();

    return res.status(200).json({
        status: 200,
        message: "Rescues Retrieved Successfully!",
        data: rescues,
    });
});

app.get("/:id", async (req, res) => {
    const { id } = req.params;

    const rescue  = await Rescue.getById(Number(id));

    if (rescue) {
        return res.status(200).json({
            status: 200,
            message: "Rescue Retrieved Successfully!",
            data: rescue,
        });
    } else {
        return res.status(404).json({
            status: 404,
            message: `Rescue with id ${id} don't exist`,
        });
    }
});

app.get("/vendor/:id", async (req, res) => {
    const { id } = req.params;

    const rescue  = await Rescue.getByVendorId(Number(id));

    if (rescue) {
        return res.status(200).json({
            status: 200,
            message: "All Vendor Rescues Retrieved Successfully!",
            data: rescue,
        });
    } else {
        return res.status(404).json({
            status: 404,
            message: `Rescue with vendor_id ${id} don't exist`,
        });
    }
});

app.get("/fii/:id", async (req, res) => {
    const { id } = req.params;

    const rescue  = await Rescue.getByFiiId(Number(id));

    if (rescue) {
        return res.status(200).json({
            status: 200,
            message: "All fii Rescues Retrieved Successfully!",
            data: rescue,
        });
    } else {
        return res.status(404).json({
            status: 404,
            message: `Rescue with fii_id ${id} don't exist`,
        });
    }
});

app.post("/", async (req, res) => {
    const { code, status, vendor_id, fii_id } = req.body;

    if (!code) return res.status(400).json({ message: 'code is required' });

    if (!vendor_id) return res.status(400).json({ message: 'vendor_id is required' });

    if (!fii_id) return res.status(400).json({ message: 'fii_id is required' });

    const rescue = await Rescue.create({
        code,
        status,
        vendor_id,
        fii_id,
    });

    if (rescue) {
        return res.status(201).json({
            status: 201,
            message: "Successfully created rescue record!",
            data: rescue,
        });
    } else {
        return res.status(500).json({
            status: 500,
            message: "Failed to create rescue record!",
        });
    }
});

app.put("/:id", async (req, res) => {
    const { id } = req.params;

    const data = req.body;

    const rescue = await Rescue.update(data, Number(id));

    if (rescue) {
        return res.status(200).json({
            status: 200,
            message: "Successfully update rescue record!",
            data: rescue,
        });
    } else {
        return res.status(500).json({
            status: 500,
            message: "Failed to update rescue record!",
        });
    }
});

app.delete("/:id", async (req, res) => {
    const { id } = req.params;

    const rescue = await Rescue.delete(Number(id));

    if (rescue) {
        return res.status(200).json({
            status: 200,
            message: "Successfully deleted rescue record!",
            data: rescue,
        });
    } else {
        return res.status(500).json({
            status: 500,
            message: "Failed to delete rescue record!",
        });
    }
});

export default app;
