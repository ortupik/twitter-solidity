// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract Twitter {

    uint16  MAX_TWEET_LENGTH = 280;
    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    mapping(address => Tweet[]) private tweets;
    address public owner;

    event TweetCreated(uint256 id, address author, string content, uint256 timestamp);

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "You are not the owner!");
        _;
    }

    function changeTweetLength(uint16 newTweetLength) public onlyOwner{
        MAX_TWEET_LENGTH = newTweetLength;
    }

    function createTweet(string memory _tweet) public {
        
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Tweet is too long!!"); 
        
        Tweet memory newTweet =  Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });
        tweets[msg.sender].push(newTweet);

        emit TweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);
    }

    function unlikeTweet(address author, uint256 id) external{
        require(tweets[author][id].id == id, "TWEEET DOES NOT EXIST");
         require(tweets[author][id].likes > 0, "TWEEET Has no LIKES");
        tweets[author][id].likes--;
    }

    function likeTweet(address author, uint256 id) external{
        require(tweets[author][id].id == id, "TWEEET DOES NOT EXIST");
        tweets[author][id].likes++;
    }

    function getTweet(uint _i) public view returns (Tweet memory) {
        return tweets[msg.sender][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory){
        return tweets[_owner];
    }

}