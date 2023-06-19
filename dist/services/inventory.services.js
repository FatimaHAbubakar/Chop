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
class Inventory {
}
_a = Inventory;
Inventory.create = (inventory) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.inventory.create({
            data: inventory
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
Inventory.get = () => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.inventory.findMany();
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
Inventory.updateStock = (qty, id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.inventory.update({
            where: {
                id
            },
            data: {
                stock: { decrement: qty }
            }
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
Inventory.getById = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.inventory.findMany({
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
Inventory.getSingleById = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.inventory.findFirst({
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
Inventory.getByVendorId = (vendor_id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.inventory.findMany({
            where: {
                vendor_id
            }
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
Inventory.update = (inventory, id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.inventory.update({
            where: {
                id
            },
            data: inventory
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
Inventory.delete = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.inventory.delete({
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
exports.default = Inventory;
//# sourceMappingURL=inventory.services.js.map