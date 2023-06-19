require('dotenv').config();
import express from 'express';
const Morgan = require('morgan');
const bodyParser = require('body-parser');
const cors = require('cors');
import Router from "./controllers/index";

const app = express();

//config
app.use(express.json());
app.use(bodyParser.json());
app.use(cors({ origin: true }));

Morgan.token('body', (req: any) => {
    return JSON.stringify(req.body)
});

app.use(Morgan(':method :url :status :response-time ms :body'));


//api routes
app.use("/api/v1", Router);

app.get("/", (req,res) => {
    res.json('Server Running!');
});

app.listen(process.env.PORT || 5000, () => {
	console.log(`Server running on port http://localhost:${process.env.PORT}`);
});

export default app;