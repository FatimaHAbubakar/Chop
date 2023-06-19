import express from "express";
const app = express.Router();
import Notification from "../services/notification.services";
import UserNotification from "../services/user.notification.services";

app.get("/", async (req, res) => {
    const notifications = await Notification.get();

    return res.status(200).json({
        status: 200,
        message: "Notifications Retrieved Successfully!",
        data: notifications,
    });

});

app.get("/:id", async (req, res) => {
    const { id } = req.params;

    const notification = await Notification.getById(Number(id));

    if (notification) {

        return res.status(200).json({
            status: 200,
            message: "Notification Retrieved Successfully!",
            data: notification,
        });

    } else {

        return res.status(404).json({
            status: 404,
            message: `Notification with id ${id} don't exist`,
        });

    }

});

app.post("/", async (req, res) => {
    const { message, inventory_id } = req.body;

    const notification = await Notification.create({
        message, inventory_id
    });

    if (notification) {

        return res.status(201).json({
            status: 201,
            message: "Successfully created Notification record!",
            data: notification,
        });

    } else {

        return res.status(500).json({
            status: 500,
            message: "Failed to create Notification record!",
        });

    }

});

app.post("/seen/:id", async (req, res) => {
    const { id } = req.params;

    const { user_id } = req.body;

    let userNotification = await UserNotification.getByNotificationId(Number(id));

    if (userNotification) {

        await UserNotification.update({ seen: true }, userNotification.id);

    } else {

        userNotification = await UserNotification.create({
            seen: true,
            notification_id: id,
            user_id
        });

    }

    if (userNotification) {

        return res.status(201).json({
            status: 201,
            message: "Successfully created UserNotification record!",
            data: userNotification,
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

    const notification = await Notification.update(data, Number(id));

    if (notification) {

        return res.status(200).json({
            status: 200,
            message: "Successfully update Notification record!",
            data: notification,
        });

    } else {

        return res.status(500).json({
            status: 500,
            message: "Failed to update Notification record!",
        });

    }

});

app.delete("/:id", async (req, res) => {
    const { id } = req.params;

    const notification = await Notification.delete(Number(id));

    if (notification) {

        return res.status(200).json({
            status: 200,
            message: "Successfully deleted Notification record!",
            data: notification,
        });

    } else {

        return res.status(500).json({
            status: 500,
            message: "Failed to delete Notification record!",
        });

    }

});

export default app;
