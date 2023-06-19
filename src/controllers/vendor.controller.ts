import express from "express";
import User from "../services/user.services";
const app = express.Router();

app.get("/", async (req, res) => {

    const vendors = await User.getByRole("VENDOR");

    return res.status(200).json({
        status: 200,
        message: "Retrieved All Vendors",
        data: vendors,
    });

});

export default app;
