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
const user_services_1 = __importDefault(require("../services/user.services"));
const app = express_1.default.Router();
app.get("/", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const vendors = yield user_services_1.default.getByRole("VENDOR");
    return res.status(200).json({
        status: 200,
        message: "Retrieved All Vendors",
        data: vendors,
    });
}));
exports.default = app;
//# sourceMappingURL=vendor.controller.js.map