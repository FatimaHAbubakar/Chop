import express from "express";
const app = express.Router();
import Review from "../services/review.services";

app.get("/", async (req, res) => {
    const reviews = await Review.get();

    return res.status(200).json({
        status: 200,
        message: "Reviews retrieved Successfully!",
        data: reviews,
    });
});

app.get("/:id", async (req, res) => {
    const { id } = req.params;

    const review = await Review.getById(Number(id));

    if (review) {
        return res.status(200).json({
            status: 200,
            message: "Review retrieved Successfully!",
            data: review,
        });
    } else {
        return res.status(404).json({
            status: 404,
            message: `Review with id ${id} don't exist`,
        });
    }
});

app.get("/vendor/:id", async (req, res) => {
    const { id } = req.params;

    const review = await Review.getByVendorId(Number(id));

    if (review) {
        return res.status(200).json({
            status: 200,
            message: "All Vendor's Review retrieved Successfully",
            data: review,
        });
    } else {
        return res.status(404).json({
            status: 404,
            message: `Review with vendor_id ${id} don't exist`,
        });
    }
});

app.post("/", async (req, res) => {
    const { star, description, vendor_id, fii_id } = req.body;

    const review = await Review.create({
        star,
        description,
        vendor_id,
        fii_id,
    });

    if (review) {
        return res.status(201).json({
            status: 201,
            message: "Successfully created review record!",
            data: review,
        });
    } else {
        return res.status(500).json({
            status: 500,
            message: "Failed to create review record!",
        });
    }
});

app.put("/:id", async (req, res) => {
    const { id } = req.params;

    const data = req.body;

    const review = await Review.update(data, Number(id));

    if (review) {
        return res.status(200).json({
            status: 200,
            message: "Successfully update review record!",
            data: review,
        });
    } else {
        return res.status(500).json({
            status: 500,
            message: "Failed to update review record!",
        });
    }
});

app.delete("/:id", async (req, res) => {
    const { id } = req.params;

    const review = await Review.delete(Number(id));

    if (review) {
        return res.status(200).json({
            status: 200,
            message: "Successfully deleted review record!",
            data: review,
        });
    } else {
        return res.status(500).json({
            status: 500,
            message: "Failed to delete review record!",
        });
    }
});

export default app;
