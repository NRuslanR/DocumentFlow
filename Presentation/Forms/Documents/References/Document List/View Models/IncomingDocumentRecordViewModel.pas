unit IncomingDocumentRecordViewModel;

interface

uses

  DocumentRecordViewModel,
  DocumentRecordViewModelDecorator,
  SysUtils,
  Classes;

type

  TIncomingDocumentRecordViewModel = class (TDocumentRecordViewModelDecorator)

    private

      FIncomingNumber: String;
      FReceiptDate: TDateTime;
      FSendingDepartmentName: String;

    protected

      function GetDocumentId: Variant; override;
      function GetKind: String; override;
      function GetKindId: Variant; override;

      procedure SetDocumentId(const Value: Variant); override;
      procedure SetKind(const Value: String); override;
      procedure SetKindId(const Value: Variant); override;

    protected

      function GetIncomingNumber: String;
      function GetReceiptDate: TDateTime;

      procedure SetIncomingNumber(const Value: String);
      procedure SetReceiptDate(const Value: TDateTime);

    public

      constructor Create(DocumentRecordViewModel: TDocumentRecordViewModel); override;

    public

      property IncomingNumber: String read GetIncomingNumber write SetIncomingNumber;
      property ReceiptDate: TDateTime read GetReceiptDate write SetReceiptDate;
      property SendingDepartmentName: String read FSendingDepartmentName write FSendingDepartmentName;

  end;

implementation

{ TIncomingDocumentRecordViewModel }

constructor TIncomingDocumentRecordViewModel.Create(
  DocumentRecordViewModel: TDocumentRecordViewModel);
begin

  inherited;

end;

function TIncomingDocumentRecordViewModel.GetDocumentId: Variant;
begin

  //Result := FDocumentId;
  Result := inherited GetDocumentId;

end;

function TIncomingDocumentRecordViewModel.GetIncomingNumber: String;
begin

  Result := FIncomingNumber;

end;

function TIncomingDocumentRecordViewModel.GetKind: String;
begin

  //Result := FKind;
  Result := inherited GetKind;
  
end;

function TIncomingDocumentRecordViewModel.GetKindId: Variant;
begin

  //Result := FKindId;
  Result := inherited GetKindId;
  
end;

function TIncomingDocumentRecordViewModel.GetReceiptDate: TDateTime;
begin

  Result := FReceiptDate;

end;

procedure TIncomingDocumentRecordViewModel.SetDocumentId(const Value: Variant);
begin

  //FDocumentId := Value;
  inherited;

end;

procedure TIncomingDocumentRecordViewModel.SetIncomingNumber(
  const Value: String);
begin

  FIncomingNumber := Value;
  
end;

procedure TIncomingDocumentRecordViewModel.SetKind(const Value: String);
begin

  //FKind := Value;
  inherited;

end;

procedure TIncomingDocumentRecordViewModel.SetKindId(const Value: Variant);
begin

  //FKindId := Value;
  inherited;

end;

procedure TIncomingDocumentRecordViewModel.SetReceiptDate(
  const Value: TDateTime);
begin

  FReceiptDate := Value;
  
end;

end.
