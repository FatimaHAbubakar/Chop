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
const review_services_1 = __importDefault(require("../services/review.services"));
app.get("/", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const reviews = yield review_services_1.default.get();
    return res.status(200).json({
        status: 200,
        message: "Reviews retrieved Successfully!",
        data: reviews,
    });
}));
app.get("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const review = yield review_services_1.default.getById(Number(id));
    if (review) {
        return res.status(200).json({
            status: 200,
            message: "Review retrieved Successfully!",
            data: review,
        });
    }
    else {
        return res.status(404).json({
            status: 404,
            message: `Review with id ${id} don't exist`,
        });
    }
}));
app.get("/vendor/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const review = yield review_services_1.default.getByVendorId(Number(id));
    if (review) {
        return res.status(200).json({
            status: 200,
            message: "All Vendor's Review retrieved Successfully",
            data: review,
        });
    }
    else {
        return res.status(404).json({
            status: 404,
            message: `Review with vendor_id ${id} don't exist`,
        });
    }
}));
app.post("/", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { star, description, vendor_id, fii_id } = req.body;
    const review = yield review_services_1.default.create({
        star,
        description,
        vendor_id,
        fii_id,
    });
    if (review) {
        return res.status(201).json({
            status: 201,
            message: "Successfully created review record!",
            data: review,
        });
    }
    else {
        return res.status(500).json({
            status: 500,
            message: "Failed to create review record!",
        });
    }
}));
app.put("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const data = req.body;
    const review = yield review_services_1.default.update(data, Number(id));
    if (review) {
        return res.status(200).json({
            status: 200,
            message: "Successfully update review record!",
            data: review,
        });
    }
    else {
        return res.status(500).json({
            status: 500,
            message: "Failed to update review record!",
        });
    }
}));
app.delete("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { id } = req.params;
    const review = yield review_services_1.default.delete(Number(id));
    if (review) {
        return res.status(200).json({
            status: 200,
            message: "Successfully deleted review record!",
            data: review,
        });
    }
    else {
        return res.status(500).json({
            status: 500,
            message: "Failed to delete review record!",
        });
    }
}));
exports.default = app;
//# sourceMappingURL=review.controller.js.map