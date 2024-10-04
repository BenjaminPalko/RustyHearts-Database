/*
 RustyHearts Database procedure fixes for up_item_update_itemcode_option, up_insert_rearing_info, up_mail_gold_payment

*/

-- ----------------------------
-- procedure structure for up_item_update_itemcode_option
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_item_update_itemcode_option]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_item_update_itemcode_option]
GO

CREATE PROCEDURE [dbo].[up_item_update_itemcode_option]
(
	@item_id     [uniqueidentifier],
	@item_code   int,
	@opt_code01  int,
	@opt_code02  int,
	@opt_code03  int,
	@opt_value01 int,
	@opt_value02 int,
	@opt_value03 int,
    @unknonw_param int  -- ???

)
as 
set nocount on

	if exists ( select [item_uid] from [dbo].N_InventoryItem WITH (NOLOCK) where item_uid = @item_id )
	begin
		update [dbo].N_InventoryItem set 
			code           = @item_code,
			option_1_code  = @opt_code01,
			option_2_code  = @opt_code02,
			option_3_code  = @opt_code03,
			option_1_value = @opt_value01,
			option_2_value = @opt_value02,
			option_3_value = @opt_value03
			where item_uid = @item_id;
	end
	else 
	begin
		update [dbo].N_EquipItem set 
			code           = @item_code,
			option_1_code  = @opt_code01,
			option_2_code  = @opt_code02,
			option_3_code  = @opt_code03,
			option_1_value = @opt_value01,
			option_2_value = @opt_value02,
			option_3_value = @opt_value03
			where item_uid = @item_id;
	end

return @@error
GO

-- ----------------------------
-- procedure structure for up_insert_rearing_info
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_rearing_info]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_rearing_info]
GO

CREATE PROCEDURE [dbo].[up_insert_rearing_info]
	@table_id 	tinyint,
	@group_id 	tinyint,
	@reating_id 	[uniqueidentifier],
	@char_id 	[uniqueidentifier],
	@type 		tinyint,
	@name 		nvarchar(16),
	@job  		tinyint,
	@level 		int,
	@index 		tinyint,
	@actionpoint 	int,
	@usedturn 	int,
	@endingid 	int,
	@rewarditem 	int,
	@createtime 	bigint,
	@vital		int,
	@intelligence	int,
	@strength	int,
	@temper		int,
	@charm		int,
	@exhaust	int,
	@angry		int,
	@normal		int,
	@good		int,
	@sadness	int,
	@height		int,
	@weight		int,
	@resilent int = 0,
	@eloquence  int = 0

as 
set nocount on
set xact_abort on


begin
	BEGIN TRAN
		insert dbo.RearingTable
	    (
		[table_id],
		[group_id],	
		[rearing_id], 
		[char_id],
		[type], 
		[name], 
		[job], 
		[level], 
		[index], 
		[actionpoint],
		[usedturn], 
		[endingid],
		[rewarditem],
		[createtime],
		[vital], 
		[intelligence], 
		[strength], 
		[temper], 
		[charm], 
		[exhaust], 
		[angry], 
		[normal],
		[good], 
		[sadness], 
		[height], 
		[weight],
		[resilent],
		[eloquence]
		)
		values( 
		@table_id,
		@group_id,
		@reating_id,
		@char_id,
		@type,
		@name,
		@job,
		@level,
		@index,
		@actionpoint,
		@usedturn,
		@endingid,
		@rewarditem,
		@createtime,
		@vital,
		@intelligence,
		@strength,
		@temper,
		@charm,
		@exhaust,
		@angry,
		@normal,
		@good,
		@sadness,
		@height,
		@weight,
		@resilent,
		@eloquence
		)


	if(@@error <> 0 )
	begin
	     ROLLBACK TRAN
	     return

	end
	
	COMMIT TRAN
end
GO

-- ----------------------------
-- procedure structure for up_mail_gold_payment
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_mail_gold_payment]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_mail_gold_payment]
GO

CREATE PROCEDURE [dbo].[up_mail_gold_payment]
@mail_id [uniqueidentifier],
@msg 	     nvarchar(350) = 'Bill'
as 
set nocount on

declare @character_id			[uniqueidentifier],
	    @sender_character_id	[uniqueidentifier],  
		@NewMailID				[uniqueidentifier]

declare @sender_name nvarchar(16),
		@recver_name nvarchar(16)

declare @my_money    int,
		@req_money   int

begin tran

    if EXISTS (select [ID] from MailTable with (READUNCOMMITTED) where [ID] = @mail_id)
		begin
			--皋老 夸没 陛咀 犬牢
			select 
				 @character_id        = [character_id]
				,@recver_name         = [receiver]
				,@sender_character_id = [send_character_id]
				,@sender_name         = [sender]
				,@req_money           = [req_gold]
			from MailTable with (READUNCOMMITTED) where [ID] = @mail_id

			--郴捣 犬牢
			SELECT @my_money = [gold] FROM [dbo].[CharacterTable] with (READUNCOMMITTED) where [character_id] = @character_id

			-- 捣 昏力
			if (@my_money - @req_money) > 0
				begin
					UPDATE [dbo].[CharacterTable] SET [gold] = (@my_money - @req_money) WHERE [character_id] = @character_id			
				end
			else
				begin
					UPDATE [dbo].[CharacterTable] SET [gold] = 0 WHERE [character_id] = @character_id			
				end

			-- 措陛 皋老 眠啊
			insert into MailTable
			values
			( NEWID(),              --0
			  @sender_character_id, --1
			  @sender_name,         --2
			  @character_id,		--3
			  @recver_name,         --4
			  @msg,       --3
			  @req_money,			--4
			  0,
			  0,
			  0,            --8
			  GETDATE(),
			  6				-- 措陛 快祈 
			);
	
		--老馆 快祈栏肺 官操扁
		UPDATE [dbo].[MailTable] 
		SET 
		 [return_day]  = 0
		,[req_gold]    = 0
		,[is_open]     = 0
        ,[create_type] = 0
		WHERE [ID] = @mail_id
		
		--官诧 皋老 沥焊 促矫 犬牢
		select * from dbo.MailTable with (READUNCOMMITTED) where [ID] = @mail_id

		end

declare @ERR int

 SET @ERR = @@ERROR
        IF @ERR <> 0 BEGIN
	RAISERROR('贸府坷幅', 16, 10)
  	IF @@TRANCOUNT <> 0  ROLLBACK
		RETURN (@ERR)
	END
       COMMIT TRAN
GO