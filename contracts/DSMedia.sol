//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Interface/IDSNftFactory.sol";

contract DSMedia {

    IDSNft public nftFactory;

    constructor(address _nftFactoryAddress) {
        nftFactory = IDSNft(_nftFactoryAddress);
    }

    error ALREADY_REGISTERED();
    error INVALID_ADDRESS();
    error INVALID();
    error USER_HAS_NOT_CREATED_A_POST_YET();
    error POST_DOES_NOT_EXIST();

    string public post;

    struct Players {
        string name;
        uint id;
        Post post;
        bool isRegistered;
        Roles roles;
    }

    uint totalLikes;
    uint totalNFTS;

    enum Roles {
        Admin,
        User
    }

    struct Group {
        string name;
        string description;
    }

    struct Post {
        uint id;
        string title;
        string comment;
        bool like;
    }
    
    mapping(address => address) player;

    mapping(uint => mapping(address => Players)) players;
    
    Players[] playersArray;
    Post[] postArray;

    function registerPlayer(
        string memory _name,
        uint8 _id
    ) public {
        if(!players[_id][msg.sender].isRegistered){
            revert("ALREADY_REGISTERED");
        }
        Players memory newPlayer = players[_id][msg.sender];
        newPlayer.name = _name;
        newPlayer.id = _id;

        playersArray.push(newPlayer);
    }

    function createPost(
        uint _id,
        string memory _title,
        string memory _comment,
        bool _like,
        address _to,
        uint _tokenId
    ) public {
        if (_to == address(0)) {
            revert("INVALID_ADDRESS");
    }
    Post memory newPost = Post({
            id: _id,
            title: _title,
            comment: _comment,
            like: _like

            
        });
        postArray.push(newPost);
        nftFactory.createNFT(_to, _tokenId);
        totalNFTS = totalNFTS + 1;
    }

    function likePost(uint _postId) public {

         if (players[_postId][msg.sender].post.id == 0) {
        revert("USER_HAS_NOT_CREATED_A_POST_YET");
    }

    if (players[_postId][msg.sender].id == 0) {
        revert("POST_DOES_NOT_EXIST");
    }

        Players memory post = players[_postId][msg.sender];
        require(!post.post.like, "POST_ALREADY_LIKED");

        post = players[_postId][msg.sender];
        post.post.like= true;

        playersArray.push(post);
        totalLikes = totalLikes + 1;
    }

      function commentPost(uint _postId, string memory _comment) public{

        if (players[_postId][msg.sender].post.id == 0) {
        revert("USER_HAS_NOT_CREATED_A_POST_YET");
    }
        if(players[_postId][msg.sender].id == 0){
            revert("INVALID");
        }
        Players memory post = players[_postId][msg.sender];

        post = players[_postId][msg.sender];
        post.post.comment = _comment;

        playersArray.push(post);

    }

     function getPostForUser(uint _postId) public view returns (Post memory) {
         if (players[_postId][msg.sender].id == 0) {
        revert("POST_DOES_NOT_EXIST");
    }

          if (players[_postId][msg.sender].post.id == 0) {
        revert("USER_HAS_NOT_CREATED_A_POST_YET");
    }

        return players[_postId][msg.sender].post;
    }
    function getUserLikes(uint _postId) public view returns(Post memory){

    }
}