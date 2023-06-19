"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
require('dotenv').config();
const express_1 = __importDefault(require("express"));
const Morgan = require('morgan');
const bodyParser = require('body-parser');
const cors = require('cors');
const index_1 = __importDefault(require("./controllers/index"));
const app = (0, express_1.default)();
//config
app.use(express_1.default.json());
app.use(bodyParser.json());
app.use(cors({ origin: true }));
Morgan.token('body', (req) => {
    return JSON.stringify(req.body);
});
app.use(Morgan(':method :url :status :response-time ms :body'));
//api routes
app.use("/api/v1", index_1.default);
app.get("/", (req, res) => {
    res.json('Server Running!');
});
app.listen(process.env.PORT || 5000, () => {
    console.log(`Server running on port http://localhost:${process.env.PORT}`);
});
exports.default = app;
//# sourceMappingURL=server.js.map