"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const app = express_1.default.Router();
const notification_services_1 = __importDefault(require("../services/notification.services"));
const user_notification_services_1 = __importDefault(require("../services/user.notification.services"));
app.get("/", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const notifications = yield notification_services_1.default.get();
    return res.status(200).json({
        status: 200,
        message: "Notifications Retrieved Successfully!",
        data: notifications,
    });
}));
app.get("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const notification = yield notification_services_1.default.getById(Number(id));
    if (notification) {
        return res.status(200).json({
            status: 200,
            message: "Notification Retrieved Successfully!",
            data: notification,
        });
    }
    else {
        return res.status(404).json({
            status: 404,
            message: `Notification with id ${id} don't exist`,
        });
    }
}));
app.post("/", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { message, inventory_id } = req.body;
    const notification = yield notification_services_1.default.create({
        message, inventory_id
    });
    if (notification) {
        return res.status(201).json({
            status: 201,
            message: "Successfully created Notification record!",
            data: notification,
        });
    }
    else {
        return res.status(500).json({
            status: 500,
            message: "Failed to create Notification record!",
        });
    }
}));
app.post("/seen/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const { user_id } = req.body;
    let userNotification = yield user_notification_services_1.default.getByNotificationId(Number(id));
    if (userNotification) {
        yield user_notification_services_1.default.update({ seen: true }, userNotification.id);
    }
    else {
        userNotification = yield user_notification_services_1.default.create({
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
    }
    else {
        return res.status(500).json({
            status: 500,
            message: "Failed to create UserNotification record!",
        });
    }
}));
app.put("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const data = req.body;
    const notification = yield notification_services_1.default.update(data, Number(id));
    if (notification) {
        return res.status(200).json({
            status: 200,
            message: "Successfully update Notification record!",
            data: notification,
        });
    }
    else {
        return res.status(500).json({
            status: 500,
            message: "Failed to update Notification record!",
        });
    }
}));
app.delete("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const notification = yield notification_services_1.default.delete(Number(id));
    if (notification) {
        return res.status(200).json({
            status: 200,
            message: "Successfully deleted Notification record!",
            data: notification,
        });
    }
    else {
        return res.status(500).json({
            status: 500,
            message: "Failed to delete Notification record!",
        });
    }
}));
exports.default = app;
//# sourceMappingURL=notification.controller.js.map