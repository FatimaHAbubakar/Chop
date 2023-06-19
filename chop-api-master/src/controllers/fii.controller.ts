import express from "express";
import User from "../services/user.services";
const app = express.Router();

app.get("/", async (req, res) => {

    const fiis = await User.getByRole("FII");

    return res.status(200).json({
        status: 200,
        message: "Retrieved All Users",
        data: fiis,
    });

});

export default app;
