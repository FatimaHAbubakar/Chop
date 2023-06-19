import express from "express";
const app = express.Router();
import UserNotification from "../services/user.notification.services";

app.get("/", async (req, res) => {
    const userNotifications = await UserNotification.get();

    return res.status(200).json({
        status: 200,
        message: "UserNotifications Retrieved Successfully!",
        data: userNotifications,
    });
});

app.get("/:id", async (req, res) => {
    const { id } = req.params;

    const userNotifications  = await UserNotification.getById(Number(id));

    if (userNotifications) {
        return res.status(200).json({
            status: 200,
            message: "UserNotification Retrieved Successfully!",
            data: userNotifications,
        });
    } else {
        return res.status(404).json({
            status: 404,
            message: `UserNotification with id ${id} don't exist`,
        });
    }
});

app.post("/", async (req, res) => {
    const { seen, notification_id, user_id } = req.body;

    if (!seen) return res.status(400).json({ message: 'seen is required (Boolean)' });

    if (!user_id) return res.status(400).json({ message: 'user_id is required' });

    if (!notification_id) return res.status(400).json({ message: 'notification_id is required' });


    const userNotifications = await UserNotification.create({
        seen,
        notification_id,
        user_id,
    });

    if (userNotifications) {
        return res.status(201).json({
            status: 201,
            message: "Successfully created UserNotification record!",
            data: userNotifications,
        });
    } else {
        return res.status(500).json({
            status: 500,
            message: "Failed to create UserNotification record!",
        });
    }
});

app.put("/:id", async (req, res) => {
    const { id } = req.params;

    const data = req.body;

    const userNotifications = await UserNotification.update(data, Number(id));

    if (userNotifications) {
        return res.status(200).json({
            status: 200,
            message: "Successfully update UserNotification record!",
            data: userNotifications,
        });
    } else {
        return res.status(500).json({
            status: 500,
            message: "Failed to update UserNotification record!",
        });
    }
});

app.delete("/:id", async (req, res) => {
    const { id } = req.params;

    const userNotifications = await UserNotification.delete(Number(id));

    if (UserNotification) {
        return res.status(200).json({
            status: 200,
            message: "Successfully deleted UserNotification record!",
            data: userNotifications,
        });
    } else {
        return res.status(500).json({
            status: 500,
            message: "Failed to delete UserNotification record!",
        });
    }
});

export default app;
