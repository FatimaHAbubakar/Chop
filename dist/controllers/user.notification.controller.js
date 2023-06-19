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
const user_notification_services_1 = __importDefault(require("../services/user.notification.services"));
app.get("/", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const userNotifications = yield user_notification_services_1.default.get();
    return res.status(200).json({
        status: 200,
        message: "UserNotifications Retrieved Successfully!",
        data: userNotifications,
    });
}));
app.get("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const userNotifications = yield user_notification_services_1.default.getById(Number(id));
    if (userNotifications) {
        return res.status(200).json({
            status: 200,
            message: "UserNotification Retrieved Successfully!",
            data: userNotifications,
        });
    }
    else {
        return res.status(404).json({
            status: 404,
            message: `UserNotification with id ${id} don't exist`,
        });
    }
}));
app.post("/", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { seen, notification_id, user_id } = req.body;
    if (!seen)
        return res.status(400).json({ message: 'seen is required (Boolean)' });
    if (!user_id)
        return res.status(400).json({ message: 'user_id is required' });
    if (!notification_id)
        return res.status(400).json({ message: 'notification_id is required' });
    const userNotifications = yield user_notification_services_1.default.create({
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
    const userNotifications = yield user_notification_services_1.default.update(data, Number(id));
    if (userNotifications) {
        return res.status(200).json({
            status: 200,
            message: "Successfully update UserNotification record!",
            data: userNotifications,
        });
    }
    else {
        return res.status(500).json({
            status: 500,
            message: "Failed to update UserNotification record!",
        });
    }
}));
app.delete("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const userNotifications = yield user_notification_services_1.default.delete(Number(id));
    if (user_notification_services_1.default) {
        return res.status(200).json({
            status: 200,
            message: "Successfully deleted UserNotification record!",
            data: userNotifications,
        });
    }
    else {
        return res.status(500).json({
            status: 500,
            message: "Failed to delete UserNotification record!",
        });
    }
}));
exports.default = app;
//# sourceMappingURL=user.notification.controller.js.map