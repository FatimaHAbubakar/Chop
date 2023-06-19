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
class Notification {
}
_a = Notification;
Notification.create = (Notification) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.notification.create({
            data: Notification
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
Notification.get = () => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.notification.findMany();
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
Notification.getById = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.notification.findFirst({
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
Notification.getByInventoryId = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.notification.findFirst({
            where: {
                inventory_id: id
            }
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
Notification.update = (Notification, id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.notification.update({
            where: {
                id
            },
            data: Notification
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
Notification.delete = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.notification.delete({
            where: {
                id
            },
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
exports.default = Notification;
//# sourceMappingURL=notification.services.js.map