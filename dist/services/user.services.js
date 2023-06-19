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
var _a;
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
class User {
}
_a = User;
User.create = (user) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.user.create({
            data: user
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
User.get = (email) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.user.findFirst({
            where: {
                email
            }
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
User.getById = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.user.findFirst({
            where: {
                id
            }
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
User.getByRole = (role) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const users = yield prisma.user.findMany({
            where: {
                role
            },
        });
        users.map(user => {
            delete user.password;
        });
        return users;
    }
    catch (error) {
        console.log(error);
    }
});
User.update = (user) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.user.update({
            where: {
                email: user.email
            },
            data: user
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
User.delete = (email) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.user.delete({
            where: {
                email: email
            },
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
exports.default = User;
//# sourceMappingURL=user.services.js.map