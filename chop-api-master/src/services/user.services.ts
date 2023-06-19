import { PrismaClient, Role } from '@prisma/client'
const prisma = new PrismaClient();

 export default class User {
    static create = async (user: any) => {

        try {
            const data = await prisma.user.create({
                data: user
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static get = async (email: string) => {

        try {

            const data = await prisma.user.findFirst({
                where: {
                    email
            }});

            return data;

        } catch (error) {

            console.log(error);

        }

     }

     static getById = async (id: any) => {

        try {

            const data = await prisma.user.findFirst({
                where: {
                    id
            }});

            return data;

        } catch (error) {

            console.log(error);

        }

     }

    static getByRole = async (role: Role) => {

        try {

            const users = await prisma.user.findMany({
                where: {
                    role
                },
            });

            users.map(user => {
                delete user.password;
            });

            return users;

        } catch (error) {

            console.log(error);

        }

    }

    static update = async (user: any) => {

        try {

            const data = await prisma.user.update({
                where: {
                    email: user.email
                },
                data: user
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static delete = async (email: string) => {

        try {

            const data = await prisma.user.update({
                where: {
                    email: email
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