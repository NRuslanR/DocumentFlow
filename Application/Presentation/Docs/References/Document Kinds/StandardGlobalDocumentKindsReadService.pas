unit StandardGlobalDocumentKindsReadService;

interface

uses

  SysUtils,
  GlobalDocumentKindsReadService,
  NativeDocumentKindsReadService,
  GlobalDocumentKindDto,
  NativeDocumentKindDto,
  DocumentKindDto,
  DocumentKinds,
  AbstractApplicationService,
  SDItemsService,
  PlantItemService,
  Hashes,
  SDItem,
  Classes;

type

  TStandardGlobalDocumentKindsReadService =
    class (TAbstractApplicationService, IGlobalDocumentKindsReadService)

      private

        FNativeDocumentKindsReadService: INativeDocumentKindsReadService;
        FSDItemsService: ISDItemsService;
        FPlantItemService: IPlantItemService;
        
      private

        procedure RaiseExceptionIfNativeDocumentKindsNotFound(
          NativeDocumentKindDtos: TNativeDocumentKindDtos
        );

      private

        function CreateGlobalDocumentKindDtosFrom(

          NativeDocumentKindDtos: TNativeDocumentKindDtos;
          var CurrentGlobalId: Integer

        ): TGlobalDocumentKindDtos; overload;

        function CreateGlobalDocumentKindDtosFrom(

          SDItems: TSDItems;
          var CurrentGlobalId: Integer
          
        ): TGlobalDocumentKindDtos; overload;

        function CreateGlobalDocumentKindDtosFrom(
        
          PlantItems: TPlantItems;
          var CurrentGlobalId: Integer

        ): TGlobalDocumentKindDtos; overload;
        
      public

        constructor Create(
          { refactor: inject global id generator }
          NativeDocumentKindsReadService: INativeDocumentKindsReadService;
          SDItemsService: ISDItemsService = nil;
          PlantItemService: IPlantItemService = nil
        );

        function GetGlobalDocumentKindDtos(const ClientId: Variant): TGlobalDocumentKindDtos;

    end;

implementation

uses

  VariantListUnit,
  Variants;

{ TStandardGlobalDocumentKindsReadService }

constructor TStandardGlobalDocumentKindsReadService.Create(
  NativeDocumentKindsReadService: INativeDocumentKindsReadService;
  SDItemsService: ISDItemsService;
  PlantItemService: IPlantItemService
);
begin

  inherited Create;

  FNativeDocumentKindsReadService := NativeDocumentKindsReadService;
  FSDItemsService := SDItemsService;
  FPlantItemService := PlantItemService;
  
end;

function TStandardGlobalDocumentKindsReadService.GetGlobalDocumentKindDtos(
  const ClientId: Variant
): TGlobalDocumentKindDtos;

var
    NativeDocumentKindDtos: TNativeDocumentKindDtos;
    SDItems: TSDItems;
    PlantItems: TPlantItems;

    CurrentGlobalId: Integer;

    GlobalDocumentKindDtosFromNative: TGlobalDocumentKindDtos;
    GlobalDocumentKindDtosFromSDItems: TGlobalDocumentKindDtos;
begin

  Result := nil;
  NativeDocumentKindDtos := nil;
  GlobalDocumentKindDtosFromNative := nil;
  GlobalDocumentKindDtosFromSDItems := nil;
  SDItems := nil;
  PlantItems := nil;

  try

    NativeDocumentKindDtos :=
      FNativeDocumentKindsReadService.GetNativeDocumentKindDtos;

    RaiseExceptionIfNativeDocumentKindsNotFound(NativeDocumentKindDtos);

    if Assigned(FSDItemsService) then begin

      try

        SDItems := FSDItemsService.GetAllSDItems;

      except

        on E: TSDItemsAccessDeniedException do SDItems := nil;

      end;

    end

    else SDItems := nil;

    if Assigned(FPlantItemService) then begin

      PlantItems := FPlantItemService.GetPlantItems(ClientId);
      
    end;


    Result := TGlobalDocumentKindDtos.Create;

    CurrentGlobalId := 0;
    
    try

      if Assigned(NativeDocumentKindDtos) then begin

        GlobalDocumentKindDtosFromNative :=
          CreateGlobalDocumentKindDtosFrom(NativeDocumentKindDtos, CurrentGlobalId);

        Result.Add(GlobalDocumentKindDtosFromNative);

      end;

      if Assigned(SDItems) then begin

        GlobalDocumentKindDtosFromSDItems :=
          CreateGlobalDocumentKindDtosFrom(SDItems, CurrentGlobalId);

        Result.Add(GlobalDocumentKindDtosFromSDItems);
        
      end;

      if Assigned(PlantItems) then
        Result.Add(CreateGlobalDocumentKindDtosFrom(PlantItems, CurrentGlobalId));

    except

      on E: Exception do begin

        FreeAndNil(Result);

        Raise;
        
      end;

    end;

  finally

    FreeAndNil(SDItems);
    FreeAndNil(PlantItems);
    FreeAndNil(NativeDocumentKindDtos);
    FreeAndNil(GlobalDocumentKindDtosFromNative);
    FreeAndNil(GlobalDocumentKindDtosFromSDItems);
    
  end;

end;

procedure TStandardGlobalDocumentKindsReadService.RaiseExceptionIfNativeDocumentKindsNotFound(
  NativeDocumentKindDtos: TNativeDocumentKindDtos);
begin

  if not Assigned(NativeDocumentKindDtos) then begin

    raise TGlobalDocumentKindsReadServiceException.Create(
      'Информация о видах документов не найдена'
    );
    
  end;

end;

function TStandardGlobalDocumentKindsReadService.CreateGlobalDocumentKindDtosFrom(

  NativeDocumentKindDtos: TNativeDocumentKindDtos;
  var CurrentGlobalId: Integer

): TGlobalDocumentKindDtos;

var
    DocumentKindDto: TDocumentKindDto;
    GlobalDocumentKindDto: TGlobalDocumentKindDto;

    WorkingGlobalIdMappings: TIntegerHash;
    WorkingIdKey: String;
    TopLevelWorkingIdKey: String;
begin

  WorkingGlobalIdMappings := TIntegerHash.Create;
  
  try

    Result := TGlobalDocumentKindDtos.Create;

    try

      for DocumentKindDto in NativeDocumentKindDtos do begin

        GlobalDocumentKindDto := TGlobalDocumentKindDto.Create;

        GlobalDocumentKindDto.WorkingId := DocumentKindDto.Id;
        GlobalDocumentKindDto.TopLevelWorkingDocumentKindId := DocumentKindDto.TopLevelDocumentKindId;
        GlobalDocumentKindDto.Name := DocumentKindDto.Name;
        GlobalDocumentKindDto.ServiceType := DocumentKindDto.ServiceType;

        WorkingIdKey := VarToStr(DocumentKindDto.Id);

        if WorkingGlobalIdMappings.Exists(WorkingIdKey) then
          GlobalDocumentKindDto.Id := WorkingGlobalIdMappings[WorkingIdKey]

        else begin

          Inc(CurrentGlobalId);

          GlobalDocumentKindDto.Id := CurrentGlobalId;

          WorkingGlobalIdMappings[WorkingIdKey] := CurrentGlobalId;

        end;

        if not VarIsNull(DocumentKindDto.TopLevelDocumentKindId) then begin

          TopLevelWorkingIdKey := VarToStr(DocumentKindDto.TopLevelDocumentKindId);

          if WorkingGlobalIdMappings.Exists(TopLevelWorkingIdKey) then begin

            GlobalDocumentKindDto.TopLevelDocumentKindId :=
              WorkingGlobalIdMappings[TopLevelWorkingIdKey];

          end

          else begin

            Inc(CurrentGlobalId);

            GlobalDocumentKindDto.TopLevelDocumentKindId := CurrentGlobalId;

            WorkingGlobalIdMappings[TopLevelWorkingIdKey] := CurrentGlobalId;
            
          end;
          
        end;

        Result.Add(GlobalDocumentKindDto);

      end;

    except

      on E: Exception do begin

        FreeAndNil(Result);

        Raise;

      end;

    end;

  finally

    FreeAndNil(WorkingGlobalIdMappings);
    
  end;

end;

function TStandardGlobalDocumentKindsReadService.CreateGlobalDocumentKindDtosFrom(

  SDItems: TSDItems;
  var CurrentGlobalId: Integer

): TGlobalDocumentKindDtos;

var

    SDItem: TSDItem;
    GlobalDocumentKindDto: TGlobalDocumentKindDto;

    WorkingGlobalIdMappings: TIntegerHash;
    WorkingIdKey: String;
    TopLevelWorkingIdKey: String;
begin

  WorkingGlobalIdMappings := TIntegerHash.Create;
  
  try

    Result := TGlobalDocumentKindDtos.Create;

    try

      for SDItem in SDItems do begin

        GlobalDocumentKindDto := TGlobalDocumentKindDto.Create;

        GlobalDocumentKindDto.WorkingId := SDItem.Id;
        GlobalDocumentKindDto.TopLevelWorkingDocumentKindId := SDItem.TopLevelSDItemId;
        GlobalDocumentKindDto.Name := SDItem.Name;
        GlobalDocumentKindDto.ServiceType := TSDDocumentKind;

        WorkingIdKey := VarToStr(SDItem.Id);
        
        if WorkingGlobalIdMappings.Exists(WorkingIdKey) then
          GlobalDocumentKindDto.Id := WorkingGlobalIdMappings[WorkingIdKey]
        
        else begin

          Inc(CurrentGlobalId);
          
          GlobalDocumentKindDto.Id := CurrentGlobalId;

          WorkingGlobalIdMappings[WorkingIdKey] := CurrentGlobalId;

        end;

        if not VarIsNull(SDItem.TopLevelSDItemId) then begin

          TopLevelWorkingIdKey := VarToStr(SDItem.TopLevelSDItemId);
          
          if WorkingGlobalIdMappings.Exists(TopLevelWorkingIdKey) then begin

            GlobalDocumentKindDto.TopLevelDocumentKindId :=
              WorkingGlobalIdMappings[TopLevelWorkingIdKey];
              
          end

          else begin

            Inc(CurrentGlobalId);

            GlobalDocumentKindDto.TopLevelDocumentKindId := CurrentGlobalId;

            WorkingGlobalIdMappings.Items[TopLevelWorkingIdKey] := CurrentGlobalId;

          end;

        end;

        Result.Add(GlobalDocumentKindDto);

      end;

    except

      on E: Exception do begin

        FreeAndNil(Result);

        Raise;

      end;

    end;

  finally

    FreeAndNil(WorkingGlobalIdMappings);
    
  end;
  
end;

function TStandardGlobalDocumentKindsReadService.CreateGlobalDocumentKindDtosFrom(
  PlantItems: TPlantItems;
  var CurrentGlobalId: Integer
): TGlobalDocumentKindDtos;
var
    PlantItem: TPlantItem;
begin

  Result := TGlobalDocumentKindDtos.Create;

  try

    for PlantItem in PlantItems do begin

      Result.Add(TGlobalDocumentKindDto.Create);

      with TGlobalDocumentKindDto(Result.Last) do begin

        WorkingId := PlantItem.Id;
        TopLevelWorkingDocumentKindId := Null;
        TopLevelDocumentKindId := Null;
        Name := PlantItem.Name;
        ServiceType := TPlantDocumentKind;

        Inc(CurrentGlobalId);
        
        Id := CurrentGlobalId;

      end;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
