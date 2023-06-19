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
class Rescue {
}
_a = Rescue;
Rescue.create = (rescue) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.rescue.create({
            data: rescue,
            include: {
                Vendor: true,
                FII: true
            }
        });
        delete data.Vendor.password;
        delete data.FII.password;
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
Rescue.get = () => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.rescue.findMany({
            include: {
                Vendor: true,
                FII: true
            }
        });
        data.map((rescue) => {
            delete rescue.Vendor.password;
            delete rescue.FII.password;
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
Rescue.getById = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.rescue.findFirst({
            where: {
                id
            },
            include: {
                Vendor: true,
                FII: true
            }
        });
        delete data.Vendor.password;
        delete data.FII.password;
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
Rescue.getByVendorId = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.rescue.findMany({
            where: {
                vendor_id: id
            },
            include: {
                Vendor: true,
                FII: true
            }
        });
        data.map((rescue) => {
            delete rescue.FII.password;
            delete rescue.Vendor.password;
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
Rescue.getByFiiId = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.rescue.findMany({
            where: {
                fii_id: id
            },
            include: {
                Vendor: true,
                FII: true
            }
        });
        data.map((rescue) => {
            delete rescue.FII.password;
            delete rescue.Vendor.password;
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
Rescue.update = (rescue, id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.rescue.update({
            where: {
                id
            },
            include: {
                Vendor: true,
                FII: true
            },
            data: rescue
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
Rescue.delete = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.rescue.delete({
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
exports.default = Rescue;
//# sourceMappingURL=rescue.services.js.map