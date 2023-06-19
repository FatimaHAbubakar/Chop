import { PrismaClient } from '@prisma/client'
const prisma = new PrismaClient();

export default class UserNotification {
    static create = async (userNotification: any) => {

        try {
            const data = await prisma.userNotification.create({
                data: userNotification
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static get = async () => {

        try {

            const data = await prisma.userNotification.findMany();

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static getById = async (id: number) => {

        try {

            const data = await prisma.userNotification.findFirst({
                where: {
                    id
                }
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static getByNotificationId = async (id: number) => {

        try {

            const data = await prisma.userNotification.findFirst({
                where: {
                    notification_id: id
                }
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static update = async (userNotification: any, id: number) => {

        try {

            const data = await prisma.userNotification.update({
                where: {
                    id
                },
                data: userNotification
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static delete = async (id: number) => {

        try {

            const data = await prisma.userNotification.update({
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