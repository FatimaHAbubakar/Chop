import { PrismaClient } from '@prisma/client'
const prisma = new PrismaClient();

export default class Notification {
    static create = async (Notification: any) => {

        try {
            const data = await prisma.notification.create({
                data: Notification
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static get = async () => {

        try {

            const data = await prisma.notification.findMany();

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static getById = async (id: number) => {

        try {

            const data = await prisma.notification.findFirst({
                where: {
                    id
                }
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static getByInventoryId = async (id: number) => {

        try {

            const data = await prisma.notification.findFirst({
                where: {
                    inventory_id: id
                }
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static update = async (Notification: any, id: number) => {

        try {

            const data = await prisma.notification.update({
                where: {
                    id
                },
                data: Notification
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static delete = async (id: number) => {

        try {

            const data = await prisma.notification.update({
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