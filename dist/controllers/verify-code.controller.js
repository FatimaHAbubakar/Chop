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
const rescue_services_1 = __importDefault(require("../services/rescue.services"));
const rescue_inventory_services_1 = __importDefault(require("../services/rescue.inventory.services"));
const inventory_services_1 = __importDefault(require("../services/inventory.services"));
app.post("/", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    const { rescue_id, code } = req.body;
    if (!rescue_id)
        return res.status(400).json({ message: 'rescue_id is required' });
    if (!code)
        return res.status(400).json({ message: 'code is required' });
    const rescue = yield rescue_services_1.default.getById(Number(rescue_id));
    if (rescue.code === code && rescue.status === "PENDING") {
        let rescueStatus = "";
        const rescueInventory = yield rescue_inventory_services_1.default.getByRescueId(rescue.id);
        if (!rescueInventory) {
            rescueStatus = "CANCELED";
            yield rescue_services_1.default.update({
                status: rescueStatus
            }, rescue.id);
            return res.status(404).json({
                status: 404,
                message: `Rescue with id ${rescue_id} is cancelled, due to not having rescue inventory`,
            });
        }
        const inventoryStock = yield inventory_services_1.default.getSingleById(rescueInventory.inventory_id);
        const difference = inventoryStock.stock - rescueInventory.quantity;
        let inventory;
        if (difference >= 0) {
            inventory = yield inventory_services_1.default.updateStock(rescueInventory.quantity, rescueInventory.inventory_id);
            rescueStatus = "COMPLETED";
        }
        else {
            rescueStatus = "CANCELED";
            return res.status(200).json({
                status: 200,
                message: `Rescue with id ${rescue_id}, not enough stock level`,
            });
        }
        const updatedRescue = yield rescue_services_1.default.update({
            status: rescueStatus
        }, rescue.id);
        (_a = updatedRescue.Vendor) === null || _a === void 0 ? true : delete _a.password;
        return res.status(200).json({
            status: 200,
            message: "Successfully updated stock",
            data: updatedRescue,
        });
    }
    else if (rescue.status === "COMPLETED") {
        return res.status(200).json({
            status: 200,
            message: `Rescue with id ${rescue_id} is and code ${code} already claimed!`,
        });
    }
    else {
        return res.status(404).json({
            status: 404,
            message: `Rescue with id ${rescue_id} don't exists OR invalid code`,
        });
    }
}));
exports.default = app;
//# sourceMappingURL=verify-code.controller.js.map