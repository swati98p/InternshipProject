var mongoose =require('mongoose');
mongoose.Promise=global.Promise;
var Schema=mongoose.Schema;
var ProductionSchema=new Schema({
	blockchainId:Number,
	name: String,
	category: String,
	ipfsImageHash:String,
	ipfsDescHash:String,
	auctionStartTime:Number,
	auctionEndTime:Number,
	price:Number,
	condition:Number,
	productStatus:Number,
});


var ProductModel =mongoose.model('ProductModel', ProductionSchema);
module.exports = ProductModel;