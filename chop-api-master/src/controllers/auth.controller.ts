import express from 'express';
import User from '../services/user.services';
import { checkPassword, generateToken, hashedPassword } from '../utils/jwt';

const app = express.Router();

app.post('/login', async (req, res) => {
    const { email, password } = req.body;

    const user = await User.get(email);

    if (!user) {
        return res.status(404).json({
            status: 404,
            message: 'User does not exist!',
        });
    }

    let isPassword = await checkPassword(password, user.password);

    if (isPassword) {

        const token = await generateToken(user);

        delete user.password;
        delete user.createdAt;
        delete user.updatedAt;

        return res.status(200).json({
            status: 200,
            message: 'User login successfully!',
            data: {
                user: user,
                access_token: token,
            },
        });

    } else {

        return res.status(500).json({
            status: 500,
            message: 'Password OR Email incorrect!',
        });

    }

});


app.post('/register', async (req, res) => {
    const { name, email, password, location, address, phone, role } = req.body;

    if (!name) return res.status(400).json({ message: 'name is required' });

    if (!email) return res.status(400).json({ message: 'email is required' });

    if (!password) return res.status(400).json({ message: 'password is required' });

    if (!role) return res.status(400).json({ message: 'role is required' });

    if (role === "VENDOR") {

        if (!location) return res.status(400).json({ message: 'location is required' });
        if (!address) return res.status(400).json({ message: 'address is required' });

    }

    if (!phone) return res.status(400).json({ message: 'phone is required' });

    const hashPassword = await hashedPassword(password);

    const data = {
        name,
        email,
        password: hashPassword,
        location,
        address,
        phone,
        role
    };

    const user = await User.create(data);

    if (user) {

        const token = await generateToken(data);

        delete user.password;

        return res.status(201).json({
            status: 201,
            message: 'User created Successfully!',
            data: {
                user,
                token,
            },
        });

    } else {

        return res.status(500).json({
            status: 500,
            message: 'Email Already Exist!',
        });

    }

});

export default app;