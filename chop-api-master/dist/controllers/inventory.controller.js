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
const inventory_services_1 = __importDefault(require("../services/inventory.services"));
const notification_services_1 = __importDefault(require("../services/notification.services"));
const user_services_1 = __importDefault(require("../services/user.services"));
app.get("/", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const inventories = yield inventory_services_1.default.get();
    return res.status(200).json({
        status: 200,
        message: "Inventories Retrieved Successfully!",
        data: inventories,
    });
}));
app.get("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const inventory = yield inventory_services_1.default.getById(Number(id));
    if (inventory) {
        return res.status(200).json({
            status: 200,
            message: "Inventory Retrieved Successfully!",
            data: inventory,
        });
    }
    else {
        return res.status(404).json({
            status: 404,
            message: `Inventory with id ${id} don't exist`,
        });
    }
}));
app.get("/vendor/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const inventory = yield inventory_services_1.default.getByVendorId(Number(id));
    if (inventory) {
        return res.status(200).json({
            status: 200,
            message: "Vendor's Inventory Retrieved Successfully!",
            data: inventory,
        });
    }
    else {
        return res.status(404).json({
            status: 404,
            message: `Inventory with id ${id} don't exist`,
        });
    }
}));
app.post("/", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { name, category, stock, vendor_id, discount, price } = req.body;
    if (!name)
        return res.status(400).json({ message: 'name is required' });
    if (!category)
        return res.status(400).json({ message: 'category is required' });
    if (!stock)
        return res.status(400).json({ message: 'stock is required' });
    if (!vendor_id)
        return res.status(400).json({ message: 'vendor_id is required' });
    if (!price)
        return res.status(400).json({ message: 'price is required' });
    const inventory = yield inventory_services_1.default.create({
        name,
        category,
        stock,
        vendor_id,
        discount: discount ? Number(discount) : null,
        price: Number(price)
    });
    if (inventory) {
        const vendor = yield user_services_1.default.getById(vendor_id);
        yield notification_services_1.default.create({
            message: `New ${inventory.name} added by ${vendor.name}`,
            inventory_id: inventory.id,
        });
        return res.status(201).json({
            status: 201,
            message: "Successfully created inventory record!",
            data: inventory,
        });
    }
    else {
        return res.status(500).json({
            status: 500,
            message: "Failed to create inventory record!",
        });
    }
}));
app.put("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const data = req.body;
    const inventory = yield inventory_services_1.default.update(data, Number(id));
    if (inventory) {
        return res.status(200).json({
            status: 200,
            message: "Successfully update inventory record!",
            data: inventory,
        });
    }
    else {
        return res.status(500).json({
            status: 500,
            message: "Failed to update inventory record!",
        });
    }
}));
app.delete("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const inventory = yield inventory_services_1.default.delete(Number(id));
    if (inventory) {
        const notification = yield notification_services_1.default.getByInventoryId(inventory.id);
        yield notification_services_1.default.delete(notification.id);
        return res.status(200).json({
            status: 200,
            message: "Successfully deleted inventory record!",
            data: inventory,
        });
    }
    else {
        return res.status(500).json({
            status: 500,
            message: "Failed to delete inventory record!",
        });
    }
}));
exports.default = app;
//# sourceMappingURL=inventory.controller.js.map