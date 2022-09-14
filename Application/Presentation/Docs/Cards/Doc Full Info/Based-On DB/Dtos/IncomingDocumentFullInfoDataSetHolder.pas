unit IncomingDocumentFullInfoDataSetHolder;

interface

uses

  DocumentInfoHolder,
  AbstractDataSetHolder,
  IncomingDocumentInfoHolder,
  DocumentFullInfoDataSetHolder,
  DocumentApprovingsInfoHolder,
  DocumentChargesInfoHolder,
  DocumentChargeSheetsInfoHolder,
  DocumentRelationsInfoHolder,
  DocumentFilesInfoHolder,
  Disposable,
  DB;

type

  TIncomingDocumentFullInfoDataSetFieldNames =
    class (TDocumentFullInfoDataSetFieldNames)

      private

      protected

        FOriginalDocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
        FFreeOriginalDocumentFullInfoDataSetFieldNames: IDisposable;
        
      protected

        function GetIncomingDocumentIdFieldName: String;
        function GetIncomingDocumentKindIdFieldName: String;
        function GetIncomingDocumentKindNameFieldName: String;
        function GetIncomingDocumentStageNameFieldName: String;
        function GetIncomingDocumentStageNumberFieldName: String;
        function GetIncomingNumberFieldName: String;
        function GetReceiptDateFieldName: String;
        
        procedure SetIncomingDocumentIdFieldName(const Value: String);
        procedure SetIncomingDocumentKindIdFieldName(const Value: String);
        procedure SetIncomingDocumentKindNameFieldName(const Value: String);
        procedure SetIncomingDocumentStageNameFieldName(const Value: String);
        procedure SetIncomingDocumentStageNumberFieldName(const Value: String);
        procedure SetIncomingNumberFieldName(const Value: String);
        procedure SetReceiptDateFieldName(const Value: String);

        function AsIncomingDocumentInfoFieldNames(DocumentInfoFieldNames: TDocumentInfoFieldNames): TIncomingDocumentInfoFieldNames;

        procedure SetOriginalDocumentFullInfoDataSetFieldNames(
          const Value: TDocumentFullInfoDataSetFieldNames
        );
        
      public

        property IncomingDocumentIdFieldName: String
        read GetIncomingDocumentIdFieldName write SetIncomingDocumentIdFieldName;

        property IncomingDocumentKindIdFieldName: String
        read GetIncomingDocumentKindIdFieldName write SetIncomingDocumentKindIdFieldName;

        property IncomingDocumentKindNameFieldName: String
        read GetIncomingDocumentKindNameFieldName write SetIncomingDocumentKindNameFieldName;

        property IncomingNumberFieldName: String
        read GetIncomingNumberFieldName write SetIncomingNumberFieldName;

        property ReceiptDateFieldName: String
        read GetReceiptDateFieldName write SetReceiptDateFieldName;

        property IncomingDocumentStageNumberFieldName: String
        read GetIncomingDocumentStageNumberFieldName
        write SetIncomingDocumentStageNumberFieldName;

        property IncomingDocumentStageNameFieldName: String
        read GetIncomingDocumentStageNameFieldName
        write SetIncomingDocumentStageNameFieldName;

        property OriginalDocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames
        read FOriginalDocumentFullInfoDataSetFieldNames
        write SetOriginalDocumentFullInfoDataSetFieldNames;
        
    end;
    
  TIncomingDocumentFullInfoDataSetHolder =
    class (TDocumentFullInfoDataSetHolder)

      private
      
      protected

        FDocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder;
        FFreeDocumentFullInfoDataSetHolder: IDisposable;

        procedure Initialize; override;

        function CreateOriginalDocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder; virtual;
        
        function CreateDocumentInfoHolderInstance: TDocumentInfoHolder; override;

        function GetFieldNames: TIncomingDocumentFullInfoDataSetFieldNames;

        function GetIncomingNumberFieldValue: String;
        function GetReceiptDateFieldValue: TDateTime;

        function GetIncomingDocumentIdFieldValue: Variant;
        function GetIncomingDocumentKindIdFieldValue: Variant;
        function GetIncomingDocumentKindNameFieldValue: String;
        function GetIncomingDocumentStageNameFieldValue: String;
        function GetIncomingDocumentStageNumberFieldValue: Integer;

        function GetIncomingDocumentInfoHolder: TIncomingDocumentInfoHolder;
        procedure SetIncomingDocumentInfoHolder(const Value: TIncomingDocumentInfoHolder);

        class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

        function GetDocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder;
        procedure SetDocumentFullInfoDataSetHolder(const Value: TDocumentFullInfoDataSetHolder);

        function AsIncomingDocumentInfoHolder(DocumentInfoHolder: TDocumentInfoHolder): TIncomingDocumentInfoHolder;
        
        procedure SetDataSet(const Value: TDataSet); override;
        
      protected

        procedure SetDocumentApprovingsInfoHolder(const Value: TDocumentApprovingsInfoHolder); override;

        procedure SetDocumentChargesInfoHolder(const Value: TDocumentChargesInfoHolder); override;

        procedure SetDocumentChargeSheetsInfoHolder(const Value: TDocumentChargeSheetsInfoHolder); override;

        procedure SetDocumentFilesInfoHolder(const Value: TDocumentFilesInfoHolder); override;
        procedure SetDocumentInfoHolder(const Value: TDocumentInfoHolder); override;

        procedure SetDocumentRelationsInfoHolder(const Value: TDocumentRelationsInfoHolder); override;

        procedure SetFieldNames(const Value: TDocumentFullInfoDataSetFieldNames); override;

      public

        constructor Create; overload; override;
        constructor Create(DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder); overload;
        
        property FieldNames: TIncomingDocumentFullInfoDataSetFieldNames
        read GetFieldNames;

        property DocumentInfoHolder: TIncomingDocumentInfoHolder
        read GetIncomingDocumentInfoHolder write SetIncomingDocumentInfoHolder;

        property DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder
        read GetDocumentFullInfoDataSetHolder write SetDocumentFullInfoDataSetHolder;
        
      published

        property IncomingNumberFieldValue: String
        read GetIncomingNumberFieldValue;

        property ReceiptDateFieldValue: TDateTime
        read GetReceiptDateFieldValue;

        property IncomingDocumentIdFieldValue: Variant
        read GetIncomingDocumentIdFieldValue;

        property IncomingDocumentKindIdFieldValue: Variant
        read GetIncomingDocumentKindIdFieldValue;

        property IncomingDocumentKindNameFieldValue: String
        read GetIncomingDocumentKindNameFieldValue;

        property IncomingDocumentStageNumberFieldValue: Integer
        read GetIncomingDocumentStageNumberFieldValue;

        property IncomingDocumentStageNameFieldValue: String
        read GetIncomingDocumentStageNameFieldValue;

    end;
  
implementation

uses

  Variants;
  
{ TIncomingDocumentFullInfoDataSetHolder }


function TIncomingDocumentFullInfoDataSetHolder.AsIncomingDocumentInfoHolder(
  DocumentInfoHolder: TDocumentInfoHolder
): TIncomingDocumentInfoHolder;
begin

  Result := DocumentInfoHolder as TIncomingDocumentInfoHolder;
  
end;

constructor TIncomingDocumentFullInfoDataSetHolder.Create(
  DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder);
begin

  inherited Create;

  Self.DocumentFullInfoDataSetHolder := DocumentFullInfoDataSetHolder;

end;

constructor TIncomingDocumentFullInfoDataSetHolder.Create;
begin

  inherited;

end;

function TIncomingDocumentFullInfoDataSetHolder.
  CreateDocumentInfoHolderInstance: TDocumentInfoHolder;
begin

  Result := TIncomingDocumentInfoHolder.Create;
  
end;

function TIncomingDocumentFullInfoDataSetHolder.
  CreateOriginalDocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder;
begin

  Result := TDocumentFullInfoDataSetHolder.Create;

end;

class function TIncomingDocumentFullInfoDataSetHolder.
  GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TIncomingDocumentFullInfoDataSetFieldNames;
  
end;

function TIncomingDocumentFullInfoDataSetHolder.
  GetDocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder;
begin

  Result := FDocumentFullInfoDataSetHolder;
  
end;

function TIncomingDocumentFullInfoDataSetHolder.GetFieldNames:
  TIncomingDocumentFullInfoDataSetFieldNames;
begin

  Result := TIncomingDocumentFullInfoDataSetFieldNames(inherited FieldNames);
  
end;

function TIncomingDocumentFullInfoDataSetHolder.
  GetIncomingDocumentIdFieldValue: Variant;
begin

  Result := DocumentInfoHolder.IncomingDocumentIdFieldValue;
            
end;

function TIncomingDocumentFullInfoDataSetHolder.GetIncomingDocumentInfoHolder: TIncomingDocumentInfoHolder;
begin

  Result := inherited DocumentInfoHolder as TIncomingDocumentInfoHolder;
  
end;

function TIncomingDocumentFullInfoDataSetHolder.GetIncomingDocumentKindIdFieldValue: Variant;
begin

  Result := IncomingDocumentKindIdFieldValue;
            
end;

function TIncomingDocumentFullInfoDataSetHolder.GetIncomingDocumentKindNameFieldValue: String;
begin

  Result := DocumentInfoHolder.IncomingDocumentKindNameFieldValue;
            
end;

function TIncomingDocumentFullInfoDataSetHolder.GetIncomingDocumentStageNameFieldValue: String;
begin

  Result := DocumentInfoHolder.IncomingDocumentStageNameFieldValue;

end;

function TIncomingDocumentFullInfoDataSetHolder.GetIncomingDocumentStageNumberFieldValue: Integer;
begin

  Result := DocumentInfoHolder.IncomingDocumentStageNumberFieldValue;
            
end;

function TIncomingDocumentFullInfoDataSetHolder.
  GetIncomingNumberFieldValue: String;
begin

  Result := DocumentInfoHolder.IncomingNumberFieldValue;
            
end;

function TIncomingDocumentFullInfoDataSetHolder.
  GetReceiptDateFieldValue: TDateTime;
begin

  Result := DocumentInfoHolder.ReceiptDateFieldValue;

end;

procedure TIncomingDocumentFullInfoDataSetHolder.Initialize;
begin

  inherited;

  DocumentFullInfoDataSetHolder := CreateOriginalDocumentFullInfoDataSetHolder;

end;

procedure TIncomingDocumentFullInfoDataSetHolder.SetDocumentFullInfoDataSetHolder(
  const Value: TDocumentFullInfoDataSetHolder);
begin

  FDocumentFullInfoDataSetHolder := Value;
  FFreeDocumentFullInfoDataSetHolder := FDocumentFullInfoDataSetHolder;

  FieldNames.OriginalDocumentFullInfoDataSetFieldNames := Value.FieldNames;

  DocumentInfoHolder.OriginalDocumentInfoHolder := FDocumentFullInfoDataSetHolder.DocumentInfoHolder;
  DocumentApprovingsInfoHolder := FDocumentFullInfoDataSetHolder.DocumentApprovingsInfoHolder;
  DocumentChargesInfoHolder := FDocumentFullInfoDataSetHolder.DocumentChargesInfoHolder;
  DocumentChargeSheetsInfoHolder := FDocumentFullInfoDataSetHolder.DocumentChargeSheetsInfoHolder;
  DocumentRelationsInfoHolder := FDocumentFullInfoDataSetHolder.DocumentRelationsInfoHolder;
  DocumentFilesInfoHolder := FDocumentFullInfoDataSetHolder.DocumentFilesInfoHolder;
  
end;

procedure TIncomingDocumentFullInfoDataSetHolder.SetDocumentInfoHolder(
  const Value: TDocumentInfoHolder);
begin


  inherited SetDocumentInfoHolder(AsIncomingDocumentInfoHolder(Value));

end;

procedure TIncomingDocumentFullInfoDataSetHolder.SetDocumentRelationsInfoHolder(
  const Value: TDocumentRelationsInfoHolder);
begin

  inherited SetDocumentRelationsInfoHolder(Value);

  DocumentFullInfoDataSetHolder.DocumentRelationsInfoHolder := Value;

end;

procedure TIncomingDocumentFullInfoDataSetHolder.SetFieldNames(
  const Value: TDocumentFullInfoDataSetFieldNames);
begin

  inherited SetFieldNames((Value as TIncomingDocumentFullInfoDataSetFieldNames));

  FieldNames.OriginalDocumentFullInfoDataSetFieldNames := 
    TIncomingDocumentFullInfoDataSetFieldNames(Value)
      .OriginalDocumentFullInfoDataSetFieldNames;

end;

procedure TIncomingDocumentFullInfoDataSetHolder.SetDataSet(
  const Value: TDataSet);
begin

  inherited SetDataSet(Value);

  DocumentFullInfoDataSetHolder.DataSet := Value;
  
end;

procedure TIncomingDocumentFullInfoDataSetHolder.SetDocumentApprovingsInfoHolder(
  const Value: TDocumentApprovingsInfoHolder);
begin

  inherited SetDocumentApprovingsInfoHolder(Value);

  DocumentFullInfoDataSetHolder.DocumentApprovingsInfoHolder := Value;

end;

procedure TIncomingDocumentFullInfoDataSetHolder.SetDocumentChargeSheetsInfoHolder(
  const Value: TDocumentChargeSheetsInfoHolder);
begin

  inherited SetDocumentChargeSheetsInfoHolder(Value);

  DocumentFullInfoDataSetHolder.DocumentChargeSheetsInfoHolder := Value;

end;

procedure TIncomingDocumentFullInfoDataSetHolder.SetDocumentChargesInfoHolder(
  const Value: TDocumentChargesInfoHolder);
begin

  inherited SetDocumentChargesInfoHolder(Value);

  DocumentFullInfoDataSetHolder.DocumentChargesInfoHolder := Value;

end;

procedure TIncomingDocumentFullInfoDataSetHolder.SetDocumentFilesInfoHolder(
  const Value: TDocumentFilesInfoHolder);
begin

  inherited SetDocumentFilesInfoHolder(Value);

  DocumentFullInfoDataSetHolder.DocumentFilesInfoHolder := Value;

end;

procedure TIncomingDocumentFullInfoDataSetHolder.SetIncomingDocumentInfoHolder(
  const Value: TIncomingDocumentInfoHolder);
begin

  inherited DocumentInfoHolder := Value;

end;

{ TIncomingDocumentFullInfoDataSetFieldNames }

function TIncomingDocumentFullInfoDataSetFieldNames.AsIncomingDocumentInfoFieldNames(
  DocumentInfoFieldNames: TDocumentInfoFieldNames): TIncomingDocumentInfoFieldNames;
begin

  Result := DocumentInfoFieldNames as TIncomingDocumentInfoFieldNames;
  
end;

function TIncomingDocumentFullInfoDataSetFieldNames.GetIncomingDocumentIdFieldName: String;
begin

  Result := AsIncomingDocumentInfoFieldNames(DocumentInfoFieldNames).IncomingDocumentIdFieldName;

end;

function TIncomingDocumentFullInfoDataSetFieldNames.GetIncomingDocumentKindIdFieldName: String;
begin

  Result := AsIncomingDocumentInfoFieldNames(DocumentInfoFieldNames).IncomingDocumentKindIdFieldName;
  
end;

function TIncomingDocumentFullInfoDataSetFieldNames.GetIncomingDocumentKindNameFieldName: String;
begin

  Result := AsIncomingDocumentInfoFieldNames(DocumentInfoFieldNames).IncomingDocumentKindNameFieldName;

end;

function TIncomingDocumentFullInfoDataSetFieldNames.GetIncomingDocumentStageNameFieldName: String;
begin

  Result := AsIncomingDocumentInfoFieldNames(DocumentInfoFieldNames).IncomingDocumentStageNameFieldName;
  
end;

function TIncomingDocumentFullInfoDataSetFieldNames.GetIncomingDocumentStageNumberFieldName: String;
begin

  Result := AsIncomingDocumentInfoFieldNames(DocumentInfoFieldNames).IncomingDocumentStageNumberFieldName;

end;

function TIncomingDocumentFullInfoDataSetFieldNames.GetIncomingNumberFieldName: String;
begin

  Result := AsIncomingDocumentInfoFieldNames(DocumentInfoFieldNames).IncomingNumberFieldName;
  
end;

function TIncomingDocumentFullInfoDataSetFieldNames.GetReceiptDateFieldName: String;
begin

  Result := AsIncomingDocumentInfoFieldNames(DocumentInfoFieldNames).ReceiptDateFieldName;
  
end;

procedure TIncomingDocumentFullInfoDataSetFieldNames.SetIncomingDocumentIdFieldName(
  const Value: String);
begin

  AsIncomingDocumentInfoFieldNames(DocumentInfoFieldNames).IncomingDocumentIdFieldName := Value;

end;

procedure TIncomingDocumentFullInfoDataSetFieldNames.SetIncomingDocumentKindIdFieldName(
  const Value: String);
begin

  AsIncomingDocumentInfoFieldNames(DocumentInfoFieldNames).IncomingDocumentKindIdFieldName := Value;

end;

procedure TIncomingDocumentFullInfoDataSetFieldNames.SetIncomingDocumentKindNameFieldName(
  const Value: String);
begin

  AsIncomingDocumentInfoFieldNames(DocumentInfoFieldNames).IncomingDocumentKindNameFieldName := Value;

end;

procedure TIncomingDocumentFullInfoDataSetFieldNames.SetIncomingDocumentStageNameFieldName(
  const Value: String);
begin

  AsIncomingDocumentInfoFieldNames(DocumentInfoFieldNames).IncomingDocumentStageNameFieldName := Value;
  
end;

procedure TIncomingDocumentFullInfoDataSetFieldNames.SetIncomingDocumentStageNumberFieldName(
  const Value: String);
begin

  AsIncomingDocumentInfoFieldNames(DocumentInfoFieldNames).IncomingDocumentStageNumberFieldName := Value;
  
end;

procedure TIncomingDocumentFullInfoDataSetFieldNames.SetIncomingNumberFieldName(
  const Value: String);
begin

  AsIncomingDocumentInfoFieldNames(DocumentInfoFieldNames).IncomingNumberFieldName := Value;
  
end;

procedure TIncomingDocumentFullInfoDataSetFieldNames.SetOriginalDocumentFullInfoDataSetFieldNames(
  const Value: TDocumentFullInfoDataSetFieldNames);
begin

  FOriginalDocumentFullInfoDataSetFieldNames := Value;
  FFreeOriginalDocumentFullInfoDataSetFieldNames := FOriginalDocumentFullInfoDataSetFieldNames;

  AsIncomingDocumentInfoFieldNames(DocumentInfoFieldNames)
    .OriginalDocumentInfoFieldNames := 
      FOriginalDocumentFullInfoDataSetFieldNames.DocumentInfoFieldNames;
      
  DocumentApprovingsInfoFieldNames := 
    FOriginalDocumentFullInfoDataSetFieldNames.DocumentApprovingsInfoFieldNames;
    
  DocumentChargesInfoFieldNames := 
    FOriginalDocumentFullInfoDataSetFieldNames.DocumentChargesInfoFieldNames;
    
  DocumentChargeSheetsInfoFieldNames := 
    FOriginalDocumentFullInfoDataSetFieldNames.DocumentChargeSheetsInfoFieldNames;
    
  DocumentRelationsInfoFieldNames := 
    FOriginalDocumentFullInfoDataSetFieldNames.DocumentRelationsInfoFieldNames;
    
  DocumentFilesInfoFieldNames := 
    FOriginalDocumentFullInfoDataSetFieldNames.DocumentFilesInfoFieldNames;

end;

procedure TIncomingDocumentFullInfoDataSetFieldNames.SetReceiptDateFieldName(
  const Value: String);
begin

  AsIncomingDocumentInfoFieldNames(DocumentInfoFieldNames).ReceiptDateFieldName := Value;

end;

end.
