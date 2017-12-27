package com.amazonaws.musicforyou;

import java.util.ArrayList;
import java.util.Map;

import com.amazonaws.auth.AWSCredentialsProvider;
import com.amazonaws.auth.ClasspathPropertiesFileCredentialsProvider;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Item;
import com.amazonaws.services.dynamodbv2.document.ItemCollection;
import com.amazonaws.services.dynamodbv2.document.PutItemOutcome;
import com.amazonaws.services.dynamodbv2.document.ScanOutcome;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.dynamodbv2.document.spec.ScanSpec;
import com.amazonaws.services.dynamodbv2.document.utils.NameMap;
import com.amazonaws.services.dynamodbv2.document.utils.ValueMap;
import com.amazonaws.services.dynamodbv2.model.AttributeDefinition;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.CreateTableRequest;
import com.amazonaws.services.dynamodbv2.model.DescribeTableResult;
import com.amazonaws.services.dynamodbv2.model.GetItemRequest;
import com.amazonaws.services.dynamodbv2.model.GetItemResult;
import com.amazonaws.services.dynamodbv2.model.KeySchemaElement;
import com.amazonaws.services.dynamodbv2.model.KeyType;
import com.amazonaws.services.dynamodbv2.model.ProvisionedThroughput;
import com.amazonaws.services.dynamodbv2.model.PutItemRequest;
import com.amazonaws.services.dynamodbv2.model.PutItemResult;
import com.amazonaws.services.dynamodbv2.model.ResourceNotFoundException;
import com.amazonaws.services.dynamodbv2.model.ScalarAttributeType;
import com.amazonaws.services.dynamodbv2.model.TableStatus;

public class TrackItem {
	
	private static TrackItem trackItem = new TrackItem();
		
	public static AWSCredentialsProvider CREDENTIALS_PROVIDER;
	public static Region REGION;
	public static String TABLE_NAME;
	public static AmazonDynamoDBClient DB_CLIENT;
	public static DynamoDB dynamoDB;
	public static Table table;
	public static ArrayList<AttributeDefinition> attributeList;

	
	private TrackItem(){
		CREDENTIALS_PROVIDER = new ClasspathPropertiesFileCredentialsProvider();
		DB_CLIENT = new AmazonDynamoDBClient(CREDENTIALS_PROVIDER);
		REGION = Region.getRegion(Regions.US_WEST_2);
		DB_CLIENT.setRegion(REGION);
		dynamoDB = new DynamoDB(DB_CLIENT);
		TABLE_NAME = "savedTracks";
		table = dynamoDB.getTable(TABLE_NAME);
		attributeList = new ArrayList<>();
		
		//Check is table exists if it does not, create it
		if(!doesTableExist(DB_CLIENT, TABLE_NAME))
		{
			System.out.println("Table is creating...");
			constructAttributeDefinitions();
			DB_CLIENT.createTable(new CreateTableRequest()
            .withTableName(TABLE_NAME)
            //Define tables key schema (Primary key)
            .withKeySchema(new KeySchemaElement("id", KeyType.HASH))
            .withAttributeDefinitions(attributeList)
            .withProvisionedThroughput(new ProvisionedThroughput(50l, 50l)));
	        System.out.println("Created Table: " + DB_CLIENT.describeTable(TABLE_NAME));
		}
		
	}
	public static TrackItem getInstance(){
		try{
			return trackItem;
		}catch(Exception e){
			System.out.println("Exception : " + e.getMessage());
		}finally{
			return trackItem;
		}
		
	}
	public static String getTABLE_NAME() {
		return TABLE_NAME;
	}
	public static AmazonDynamoDBClient getDB_CLIENT() {
		return DB_CLIENT;
	}
	public void constructAttributeDefinitions(){
		attributeList.add(new AttributeDefinition("id", ScalarAttributeType.S));
	}
	
	public int insertToDB(Track track){
		
		if(table.getItem("id",track.getTrack_id()) == null){
			Item item = new Item()
				.withPrimaryKey("id",track.getTrack_id())
				.withString("name", track.getTrack_name())
				.withString("artist", track.getArtist_name())
				.withString("album", track.getAlbum_name())
				.withString("image", track.getAlbum_cover())
				.withString("url", track.getPreview_url())
				.withInt("key", track.getTrack_key())
				.withInt("bpm", track.getTrack_tempo());
			
			PutItemOutcome outcome = table.putItem(item);
			
			System.out.println("outcome: " + outcome.getPutItemResult().toString());
			
			if(table.getItem("id",track.getTrack_id()) != null){
				System.out.println("Table Status: " + DB_CLIENT.describeTable(TABLE_NAME));
				System.out.println("Track: " + track.getTrack_name() + " is inserted to DB");
				return 1;
			}else {
				System.out.println("Track: " + track.getTrack_name() + " is not inserted");
				return 2;
			}
		}else {
			System.out.println("Track: " + track.getTrack_name() + " already exists..");
			return 0;
		}
		
	}
	
	public ItemCollection<ScanOutcome> scanTable(int key,int bpm_1, int bpm_2){
			ScanSpec scanSpec = new ScanSpec()
			.withFilterExpression("#ke = :track_key AND bpm BETWEEN :from_bpm AND :to_bpm")
			.withNameMap(new NameMap().with("#ke", "key"))
			.withValueMap(new ValueMap().withNumber(":track_key", key).withNumber(":from_bpm", bpm_1).withNumber(":to_bpm", bpm_2));
			
		
		try{
			ItemCollection<ScanOutcome> items = table.scan(scanSpec);
			return items;
		}catch(Exception e){
			System.out.println(e.getMessage());
		}
		return null;
	}
	
	private boolean doesTableExist(AmazonDynamoDBClient dynamo, String tableName) {
        try {
        	DescribeTableResult table = dynamo.describeTable(tableName);
            return TableStatus.ACTIVE.toString().equals(table.getTable().getTableStatus());
        } catch (ResourceNotFoundException rnfe) {
            return false;
        }
	}
	
}
