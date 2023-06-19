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
Object.defineProperty(exports, "__esModule", { value: true });
exports.verifyToken = exports.generateToken = exports.checkPassword = exports.hashedPassword = void 0;
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const hashedPassword = (password) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const salt_round = 10;
        const salt = yield bcrypt.genSalt(salt_round);
        const hash = yield bcrypt.hash(password, salt);
        return hash;
    }
    catch (error) {
        console.log(error);
    }
});
exports.hashedPassword = hashedPassword;
const checkPassword = (password, hashedPassword) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        return yield bcrypt.compare(password, hashedPassword);
    }
    catch (error) {
        console.log(error);
    }
});
exports.checkPassword = checkPassword;
const generateToken = (data) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const token = jwt.sign({ data }, process.env.SECRET_KEY, { expiresIn: '30d' });
        return token;
    }
    catch (error) {
        console.log(error);
    }
});
exports.generateToken = generateToken;
const verifyToken = (token) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const result = jwt.verify(token, process.env.SECRET_KEY);
        return result;
    }
    catch (error) {
        console.log(error);
    }
});
exports.verifyToken = verifyToken;
//# sourceMappingURL=jwt.js.map