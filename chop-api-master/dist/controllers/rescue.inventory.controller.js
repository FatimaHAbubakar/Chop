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
const rescue_inventory_services_1 = __importDefault(require("../services/rescue.inventory.services"));
app.get("/", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const rescueInventories = yield rescue_inventory_services_1.default.get();
    return res.status(200).json({
        status: 200,
        message: "Rescue Inventories Retrieved Successfully!",
        data: rescueInventories,
    });
}));
app.get("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const rescueInventory = yield rescue_inventory_services_1.default.getById(Number(id));
    if (rescueInventory) {
        return res.status(200).json({
            status: 200,
            message: "RescueInventory Retrieved Successfully!",
            data: rescueInventory,
        });
    }
    else {
        return res.status(404).json({
            status: 404,
            message: `RescueInventory with id ${id} don't exist`,
        });
    }
}));
app.get("/rescue/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const rescueInventory = yield rescue_inventory_services_1.default.getByAllRescueId(Number(id));
    if (rescueInventory) {
        return res.status(200).json({
            status: 200,
            message: "RescueInventory Retrieved Successfully!",
            data: rescueInventory,
        });
    }
    else {
        return res.status(404).json({
            status: 404,
            message: `RescueInventory with id ${id} don't exist`,
        });
    }
}));
app.get("/vendor/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const rescueInventory = yield rescue_inventory_services_1.default.getByVendorId(Number(id));
    if (rescueInventory) {
        return res.status(200).json({
            status: 200,
            message: "Vendor Rescue Inventory Retrieved Successfully!",
            data: rescueInventory,
        });
    }
    else {
        return res.status(404).json({
            status: 404,
            message: `Vendor Rescue Inventory with id ${id} don't exist`,
        });
    }
}));
app.get("/fii/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const rescueInventory = yield rescue_inventory_services_1.default.getByFiiId(Number(id));
    if (rescueInventory) {
        return res.status(200).json({
            status: 200,
            message: "Fii Rescue Inventory Retrieved Successfully!",
            data: rescueInventory,
        });
    }
    else {
        return res.status(404).json({
            status: 404,
            message: `Fii Rescue Inventory with id ${id} don't exist`,
        });
    }
}));
app.post("/", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { rescue_id, inventory_id, quantity } = req.body;
    if (!rescue_id)
        return res.status(400).json({ message: 'rescue_id is required' });
    if (!quantity)
        return res.status(400).json({ message: 'quantity is required' });
    if (!inventory_id)
        return res.status(400).json({ message: 'inventory_id is required' });
    const rescueInventory = yield rescue_inventory_services_1.default.create({
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
    }
    else {
        return res.status(500).json({
            status: 500,
            message: "Failed to create RescueInventory record!",
        });
    }
}));
app.put("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const data = req.body;
    const rescueInventory = yield rescue_inventory_services_1.default.update(data, Number(id));
    if (rescueInventory) {
        return res.status(200).json({
            status: 200,
            message: "Successfully update RescueInventory record!",
            data: rescueInventory,
        });
    }
    else {
        return res.status(500).json({
            status: 500,
            message: "Failed to update RescueInventory record!",
        });
    }
}));
app.delete("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const rescueInventory = yield rescue_inventory_services_1.default.delete(Number(id));
    if (rescueInventory) {
        return res.status(200).json({
            status: 200,
            message: "Successfully deleted RescueInventory record!",
            data: rescueInventory,
        });
    }
    else {
        return res.status(500).json({
            status: 500,
            message: "Failed to delete RescueInventory record!",
        });
    }
}));
exports.default = app;
//# sourceMappingURL=rescue.inventory.controller.js.map