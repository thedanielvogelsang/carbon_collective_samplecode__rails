require 'rails_helper'

RSpec.describe UserGeneration, type: :model do
  before(:each) do
    @user1 = User.create(first: "D", last: "V", password: "p", email: "dv@gmail.com", generation: 0)
      @user2 = User.create(first: "Tommy", last: "Vogel", password: "p", email: "tv@gmail.com", generation: 1)
        UserGeneration.create(parent_id: @user1.id, child_id: @user2.id)
        @user5 = User.create(first: "Lisa", last: "Blitz", password: "p", email: "lisa_b@gmail.com", generation: 2)
        @user6 = User.create(first: "Greg", last: "Blitz", password: "p", email: "greg_b@gmail.com", generation: 2)
          UserGeneration.create(parent_id: @user2.id, child_id: @user5.id)
          UserGeneration.create(parent_id: @user2.id, child_id: @user6.id)
          @user8 = User.create(first: "Dianna", last: "Andreson", password: "p", email: "dandreson@gmail.com", generation: 3)
            UserGeneration.create(parent_id: @user6.id, child_id: @user8.id)
            @user9 = User.create(first: "Frank", last: "Andreson", password: "p", email: "frankky_123@gmail.com", generation: 4)
              UserGeneration.create(parent_id: @user8.id, child_id: @user9.id)
      @user3 = User.create(first: "James", last: "Ross", password: "p", email: "whosyourdaddy@gmail.com", generation: 1)
        UserGeneration.create(parent_id: @user1.id, child_id: @user3.id)
        @user4 = User.create(first: "Drake", last: "Garrett", password: "p", email: "dgar@gmail.com", generation: 2)
          UserGeneration.create(parent_id: @user3.id, child_id: @user4.id)
          @user7 = User.create(first: "Georgiona", last: "Stefanopoulis", password: "p", email: "georginita@gmail.com", generation: 3)
            UserGeneration.create(parent_id: @user4.id, child_id: @user7.id)
        end
  context 'model-validations' do
    it {should belong_to(:parent)}
    it {should belong_to(:child)}
    it "makes the correct associations" do
      # user does not have a parent, out of the box
      @user10 = User.create(first: "New", last: "User", email: "nu@gmail.com", password: '123abc', generation: 5)
          expect(@user10.parent).to be nil
      # nor user9 (from which came the 'invite') a child
          expect(@user9.children.empty?).to be true

      #Creating a UserGeneration record links parent with child
      UserGeneration.create(parent_id: @user9.id, child_id: @user10.id)
      child = User.find(@user10.id)
      parent = User.find(@user9.id)

          expect(child.parent).to eq(parent)
          expect(parent.children.count).to eq(1)
          expect(parent.children.first).to eq(child)
    end
  end
  context 'binding generations' do
    it 'correctly associates multiple generations' do
      @user10 = User.create(first: "New", last: "User", email: "nu@gmail.com", password: '123abc', generation: 5)
      UserGeneration.create(parent_id: @user9.id, child_id: @user10.id)
      UserGeneration.bind_generations(User.last, @user10.id)

      #now running parent returns something different
      child = User.find(@user10.id)
      parent = User.find(@user9.id)

          #doesnt return the inviter
          expect(child.parent).to_not eq(parent)
          #but rather the system root, generation 0
          expect(child.parent).to eq(@user1)
          expect(child.parent.generation).to eq(0)

          #parent now links all their tree
          expect(parent.children.count).to eq(1)
          expect(parent.children.first).to eq(child)

          #however we preserve the ability to see original inviter with #immediate_parent
          expect(child.immediate_parent).to eq(parent)
          expect(child.immediate_parent.generation).to eq(child.generation - 1)
    end
  end
  context 'generational relationships between users' do
    it "links the original parent as parent of all users" do
      @user2 = User.find(@user2.id)
      @user3 = User.find(@user3.id)
      @user4 = User.find(@user4.id)
      @user5 = User.find(@user5.id)
      @user6 = User.find(@user6.id)
      @user7 = User.find(@user7.id)
      @user8 = User.find(@user8.id)
      @user9 = User.find(@user9.id)
      UserGeneration.bind_generations(@user2, @user2.id)
      UserGeneration.bind_generations(@user3, @user3.id)
      UserGeneration.bind_generations(@user4, @user4.id)
      UserGeneration.bind_generations(@user5, @user5.id)
      UserGeneration.bind_generations(@user6, @user6.id)
      UserGeneration.bind_generations(@user7, @user7.id)
      UserGeneration.bind_generations(@user8, @user8.id)
      UserGeneration.bind_generations(@user9, @user9.id)
      @user2 = User.find(@user2.id)
      @user3 = User.find(@user3.id)
      @user4 = User.find(@user4.id)
      @user5 = User.find(@user5.id)
      @user6 = User.find(@user6.id)
      @user7 = User.find(@user7.id)
      @user8 = User.find(@user8.id)
      @user9 = User.find(@user9.id)
          expect(@user2.parent).to eq(@user1)
          expect(@user3.parent).to eq(@user1)
          expect(@user4.parent).to eq(@user1)
          expect(@user5.parent).to eq(@user1)
          expect(@user6.parent).to eq(@user1)
          expect(@user7.parent).to eq(@user1)
          expect(@user8.parent).to eq(@user1)
          expect(@user9.parent).to eq(@user1)
    end
    it "each can call their own immediate parent however" do
      @user2 = User.find(@user2.id)
      @user3 = User.find(@user3.id)
      @user4 = User.find(@user4.id)
      @user5 = User.find(@user5.id)
      @user6 = User.find(@user6.id)
      @user7 = User.find(@user7.id)
      @user8 = User.find(@user8.id)
      @user9 = User.find(@user9.id)
      UserGeneration.bind_generations(@user2, @user2.id)
      UserGeneration.bind_generations(@user3, @user3.id)
      UserGeneration.bind_generations(@user4, @user4.id)
      UserGeneration.bind_generations(@user5, @user5.id)
      UserGeneration.bind_generations(@user6, @user6.id)
      UserGeneration.bind_generations(@user7, @user7.id)
      UserGeneration.bind_generations(@user8, @user8.id)
      UserGeneration.bind_generations(@user9, @user9.id)
      @user2 = User.find(@user2.id)
      @user3 = User.find(@user3.id)
      @user4 = User.find(@user4.id)
      @user5 = User.find(@user5.id)
      @user6 = User.find(@user6.id)
      @user7 = User.find(@user7.id)
      @user8 = User.find(@user8.id)
      @user9 = User.find(@user9.id)
          expect(@user2.immediate_parent).to eq(@user1)
          expect(@user3.immediate_parent).to eq(@user1)
          expect(@user4.immediate_parent).to eq(@user3)
          expect(@user5.immediate_parent).to eq(@user2)
          expect(@user6.immediate_parent).to eq(@user2)
          expect(@user7.immediate_parent).to eq(@user4)
          expect(@user8.immediate_parent).to eq(@user6)
          expect(@user9.immediate_parent).to eq(@user8)
    end
    it "each can call their immediate descendants" do
      @user2 = User.find(@user2.id)
      @user3 = User.find(@user3.id)
      @user4 = User.find(@user4.id)
      @user5 = User.find(@user5.id)
      @user6 = User.find(@user6.id)
      @user7 = User.find(@user7.id)
      @user8 = User.find(@user8.id)
      @user9 = User.find(@user9.id)
      UserGeneration.bind_generations(@user2, @user2.id)
      UserGeneration.bind_generations(@user3, @user3.id)
      UserGeneration.bind_generations(@user4, @user4.id)
      UserGeneration.bind_generations(@user5, @user5.id)
      UserGeneration.bind_generations(@user6, @user6.id)
      UserGeneration.bind_generations(@user7, @user7.id)
      UserGeneration.bind_generations(@user8, @user8.id)
      UserGeneration.bind_generations(@user9, @user9.id)
      @user1 = User.find(@user1.id)
      @user2 = User.find(@user2.id)
      @user3 = User.find(@user3.id)
      @user4 = User.find(@user4.id)
      @user5 = User.find(@user5.id)
      @user6 = User.find(@user6.id)
      @user7 = User.find(@user7.id)
      @user8 = User.find(@user8.id)
      @user9 = User.find(@user9.id)
          # expect(@user1.children.count).to eq(8)
          expect(@user2.children.count).to eq(2)
          expect(@user3.children.count).to eq(1)
          expect(@user4.children.count).to eq(1)
          expect(@user5.children.count).to eq(0)
          expect(@user6.children.count).to eq(1)
          expect(@user7.children.count).to eq(0)
          expect(@user8.children.count).to eq(1)
          expect(@user9.children.count).to eq(0)
    end
    it "original generation can call all descendants however" do
      @user2 = User.find(@user2.id)
      @user3 = User.find(@user3.id)
      @user4 = User.find(@user4.id)
      @user5 = User.find(@user5.id)
      @user6 = User.find(@user6.id)
      @user7 = User.find(@user7.id)
      @user8 = User.find(@user8.id)
      @user9 = User.find(@user9.id)
      UserGeneration.bind_generations(@user2, @user2.id)
      UserGeneration.bind_generations(@user3, @user3.id)
      UserGeneration.bind_generations(@user4, @user4.id)
      UserGeneration.bind_generations(@user5, @user5.id)
      UserGeneration.bind_generations(@user6, @user6.id)
      UserGeneration.bind_generations(@user7, @user7.id)
      UserGeneration.bind_generations(@user8, @user8.id)
      UserGeneration.bind_generations(@user9, @user9.id)
      @user1 = User.find(@user1.id)

          expect(@user1.children.count).to eq(8)

    end
    it "all_children can be called to view all children" do
      @user2 = User.find(@user2.id)
      @user3 = User.find(@user3.id)
      @user4 = User.find(@user4.id)
      @user5 = User.find(@user5.id)
      @user6 = User.find(@user6.id)
      @user7 = User.find(@user7.id)
      @user8 = User.find(@user8.id)
      @user9 = User.find(@user9.id)
      UserGeneration.bind_generations(@user2, @user2.id)
      UserGeneration.bind_generations(@user3, @user3.id)
      UserGeneration.bind_generations(@user4, @user4.id)
      UserGeneration.bind_generations(@user5, @user5.id)
      UserGeneration.bind_generations(@user6, @user6.id)
      UserGeneration.bind_generations(@user7, @user7.id)
      UserGeneration.bind_generations(@user8, @user8.id)
      UserGeneration.bind_generations(@user9, @user9.id)
      @user1 = User.find(@user1.id)
      @user2 = User.find(@user2.id)
      @user3 = User.find(@user3.id)
      @user4 = User.find(@user4.id)
      @user5 = User.find(@user5.id)
      @user6 = User.find(@user6.id)
      @user7 = User.find(@user7.id)
      @user8 = User.find(@user8.id)
      @user9 = User.find(@user9.id)
      #all_children method calls all children in lineage
          expect(@user1.all_children.count).to eq(8)
          #OG user .children is same as .all_children!
          expect(@user1.all_children == @user1.children.order(id: :asc).to_a).to be true
          expect(@user2.all_children.count).to eq(4)
          expect(@user2.all_children == @user2.children.order(id: :asc).to_a).to be false
          expect(@user3.all_children.count).to eq(2)
          expect(@user4.all_children.count).to eq(1)
          expect(@user5.all_children.count).to eq(0)
          expect(@user6.all_children.count).to eq(2)
          expect(@user7.all_children.count).to eq(0)
          expect(@user8.all_children.count).to eq(1)
          expect(@user9.all_children.count).to eq(0)
    end
  end
end
