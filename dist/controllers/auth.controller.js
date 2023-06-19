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
const jwt_1 = require("../utils/jwt");
const app = express_1.default.Router();
app.post('/login', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { email, password } = req.body;
    const user = yield user_services_1.default.get(email);
    if (!user) {
        return res.status(404).json({
            status: 404,
            message: 'User does not exist!',
        });
    }
    let isPassword = yield (0, jwt_1.checkPassword)(password, user.password);
    if (isPassword) {
        const token = yield (0, jwt_1.generateToken)(user);
        delete user.password;
        delete user.createdAt;
        delete user.updatedAt;
        return res.status(200).json({
            status: 200,
            message: 'User login successfully!',
            data: {
                user: user,
                access_token: token,
            },
        });
    }
    else {
        return res.status(500).json({
            status: 500,
            message: 'Password OR Email incorrect!',
        });
    }
}));
app.post('/register', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { name, email, password, location, address, phone, role } = req.body;
    if (!name)
        return res.status(400).json({ message: 'name is required' });
    if (!email)
        return res.status(400).json({ message: 'email is required' });
    if (!password)
        return res.status(400).json({ message: 'password is required' });
    if (!role)
        return res.status(400).json({ message: 'role is required' });
    if (role === "VENDOR") {
        if (!location)
            return res.status(400).json({ message: 'location is required' });
        if (!address)
            return res.status(400).json({ message: 'address is required' });
    }
    if (!phone)
        return res.status(400).json({ message: 'phone is required' });
    const hashPassword = yield (0, jwt_1.hashedPassword)(password);
    const data = {
        name,
        email,
        password: hashPassword,
        location,
        address,
        phone,
        role
    };
    const user = yield user_services_1.default.create(data);
    if (user) {
        const token = yield (0, jwt_1.generateToken)(data);
        delete user.password;
        return res.status(201).json({
            status: 201,
            message: 'User created Successfully!',
            data: {
                user,
                token,
            },
        });
    }
    else {
        return res.status(500).json({
            status: 500,
            message: 'Email Already Exist!',
        });
    }
}));
exports.default = app;
//# sourceMappingURL=auth.controller.js.map