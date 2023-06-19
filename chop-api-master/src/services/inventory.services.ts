import { PrismaClient } from '@prisma/client'
const prisma = new PrismaClient();

export default class Inventory {
    static create = async (inventory: any) => {

        try {
            const data = await prisma.inventory.create({
                data: inventory
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static get = async () => {

        try {

            const data = await prisma.inventory.findMany();

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static updateStock = async (qty: number, id: number) => {

        try {

            const data = await prisma.inventory.update({
                where: {
                    id
                },
                data: {
                    stock: {decrement: qty}
                }
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static getById = async (id: number) => {

        try {

            const data = await prisma.inventory.findMany({
                where: {
                    id
                }
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static getSingleById = async (id: number) => {

        try {

            const data = await prisma.inventory.findFirst({
                where: {
                    id
                }
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static getByVendorId = async (vendor_id: number) => {

        try {

            const data = await prisma.inventory.findMany({
                where: {
                    vendor_id
                }
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static update = async (inventory: any, id: number) => {

        try {

            const data = await prisma.inventory.update({
                where: {
                    id
                },
                data: inventory
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static delete = async (id: number) => {

        try {

            const data = await prisma.inventory.update({
                where: {
                    id
                },
                data: {
                    deleted: true
                }
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }
}