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
app.get("/", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const rescues = yield rescue_services_1.default.get();
    return res.status(200).json({
        status: 200,
        message: "Rescues Retrieved Successfully!",
        data: rescues,
    });
}));
app.get("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const rescue = yield rescue_services_1.default.getById(Number(id));
    if (rescue) {
        return res.status(200).json({
            status: 200,
            message: "Rescue Retrieved Successfully!",
            data: rescue,
        });
    }
    else {
        return res.status(404).json({
            status: 404,
            message: `Rescue with id ${id} don't exist`,
        });
    }
}));
app.get("/vendor/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const rescue = yield rescue_services_1.default.getByVendorId(Number(id));
    if (rescue) {
        return res.status(200).json({
            status: 200,
            message: "All Vendor Rescues Retrieved Successfully!",
            data: rescue,
        });
    }
    else {
        return res.status(404).json({
            status: 404,
            message: `Rescue with vendor_id ${id} don't exist`,
        });
    }
}));
app.get("/fii/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const rescue = yield rescue_services_1.default.getByFiiId(Number(id));
    if (rescue) {
        return res.status(200).json({
            status: 200,
            message: "All fii Rescues Retrieved Successfully!",
            data: rescue,
        });
    }
    else {
        return res.status(404).json({
            status: 404,
            message: `Rescue with fii_id ${id} don't exist`,
        });
    }
}));
app.post("/", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { code, status, vendor_id, fii_id } = req.body;
    if (!code)
        return res.status(400).json({ message: 'code is required' });
    if (!vendor_id)
        return res.status(400).json({ message: 'vendor_id is required' });
    if (!fii_id)
        return res.status(400).json({ message: 'fii_id is required' });
    const rescue = yield rescue_services_1.default.create({
        code,
        status,
        vendor_id,
        fii_id,
    });
    if (rescue) {
        return res.status(201).json({
            status: 201,
            message: "Successfully created rescue record!",
            data: rescue,
        });
    }
    else {
        return res.status(500).json({
            status: 500,
            message: "Failed to create rescue record!",
        });
    }
}));
app.put("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const data = req.body;
    const rescue = yield rescue_services_1.default.update(data, Number(id));
    if (rescue) {
        return res.status(200).json({
            status: 200,
            message: "Successfully update rescue record!",
            data: rescue,
        });
    }
    else {
        return res.status(500).json({
            status: 500,
            message: "Failed to update rescue record!",
        });
    }
}));
app.delete("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const rescue = yield rescue_services_1.default.delete(Number(id));
    if (rescue) {
        return res.status(200).json({
            status: 200,
            message: "Successfully deleted rescue record!",
            data: rescue,
        });
    }
    else {
        return res.status(500).json({
            status: 500,
            message: "Failed to delete rescue record!",
        });
    }
}));
exports.default = app;
//# sourceMappingURL=rescue.controller.js.map