import { PrismaClient } from '@prisma/client'
const prisma = new PrismaClient();

export default class Rescue {

    static create = async (rescue: any) => {

        try {
            const data = await prisma.rescue.create({
                data: rescue,
                include: {
                    Vendor: true,
                    FII: true
                }
            });

            delete data.Vendor.password;
            delete data.FII.password;

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static get = async () => {

        try {

            const data = await prisma.rescue.findMany({
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

        } catch (error) {

            console.log(error);

        }

    }

    static getById = async (id: number) => {

        try {

            const data = await prisma.rescue.findFirst({
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

        } catch (error) {

            console.log(error);

        }

    }

    static getByVendorId = async (id: number) => {

        try {

            const data = await prisma.rescue.findMany({
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

        } catch (error) {

            console.log(error);

        }

    }

    static getByFiiId = async (id: number) => {

        try {

            const data = await prisma.rescue.findMany({
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

        } catch (error) {

            console.log(error);

        }

    }

    static update = async (rescue: any, id: number) => {

        try {

            const data = await prisma.rescue.update({
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

        } catch (error) {

            console.log(error);

        }

    }

    static delete = async (id: number) => {

        try {

            const data = await prisma.rescue.update({
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
