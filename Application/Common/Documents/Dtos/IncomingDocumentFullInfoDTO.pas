unit IncomingDocumentFullInfoDTO;

interface

uses

  DocumentResponsibleInfoDTO,
  DocumentFlowEmployeeInfoDTO,
  DocumentFullInfoDTO,
  DocumentChargeSheetsInfoDTO,
  IGetSelfUnit,
  SysUtils,
  Classes;

type

  TIncomingDocumentDTO = class (TDocumentDTO)

    private

      FOriginalDocumentDTO: TDocumentDTO;
      FFreeOriginalDocumentDTO: IGetSelf;

      procedure SetOriginalDocumentDTO(const Value: TDocumentDTO);
      
    protected

      function GetApprovingsInfoDTO: TDocumentApprovingsInfoDTO; override;
      function GetAuthorDTO: TDocumentFlowEmployeeInfoDTO; override;
      function GetChargesInfoDTO: TDocumentChargesInfoDTO; override;
      function GetContent: String; override;
      function GetProductCode: String; override;
      function GetCreationDate: TDateTime; override;
      function GetDocumentDate: Variant; override;
      function GetCurrentWorkCycleStageName: String; override;
      function GetCurrentWorkCycleStageNumber: Integer; override;
      function GetId: Variant; override;
      function GetKind: String; override;
      function GetKindId: Variant; override;
      function GetName: String; override;
      function GetFullName: String; override;
      function GetNote: String; override;
      function GetNumber: String; override;
      function GetResponsibleInfoDTO: TDocumentResponsibleInfoDTO; override;
      function GetSeparatorOfNumberParts: String; override;
      function GetIsSelfRegistered: Variant; override;
      
      function GetSigningsInfoDTO: TDocumentSigningsInfoDTO; override;
      procedure SetApprovingsInfoDTO(const Value: TDocumentApprovingsInfoDTO); override;
      procedure SetAuthorDTO(const Value: TDocumentFlowEmployeeInfoDTO); override;
      procedure SetChargesInfoDTO(const Value: TDocumentChargesInfoDTO); override;
      procedure SetContent(const Value: String); override;
      procedure SetCreationDate(const Value: TDateTime); override;
      procedure SetDocumentDate(const Value: Variant); override;
      procedure SetCurrentWorkCycleStageName(const Value: String); override;
      procedure SetCurrentWorkCycleStageNumber(const Value: Integer); override;
      procedure SetId(const Value: Variant); override;
      procedure SetKind(const Value: String); override;
      procedure SetKindId(const Value: Variant); override;
      procedure SetProductCode(const Value: String); override;
      procedure SetName(const Value: String); override;
      procedure SetFullName(const Value: String); override;
      procedure SetNote(const Value: String); override;
      procedure SetNumber(const Value: String); override;
      procedure SetResponsibleInfoDTO(const Value: TDocumentResponsibleInfoDTO); override;
      procedure SetSeparatorOfNumberParts(const Value: String); override;
      procedure SetSigningsInfoDTO(const Value: TDocumentSigningsInfoDTO); override;
      procedure SetIsSelfRegistered(const Value: Variant); override;
      
    public

      IncomingNumber: String;
      IncomingNumberPartsSeparator: String;
      ReceiptDate: TDateTime;

      property OriginalDocumentDTO: TDocumentDTO
      read FOriginalDocumentDTO write SetOriginalDocumentDTO;

  end;

  TIncomingDocumentFullInfoDTO = class (TDocumentFullInfoDTO)

    private

      function GetIncomingDocumentDTO: TIncomingDocumentDTO;
      procedure SetIncomingDocumentDTO(const Value: TIncomingDocumentDTO);

    public

      property DocumentDTO: TIncomingDocumentDTO
      read GetIncomingDocumentDTO write SetIncomingDocumentDTO;

  end;

implementation

{ TIncomingDocumentDTO }

function TIncomingDocumentDTO.GetApprovingsInfoDTO: TDocumentApprovingsInfoDTO;
begin

  Result := OriginalDocumentDTO.ApprovingsInfoDTO;
  
end;

function TIncomingDocumentDTO.GetAuthorDTO: TDocumentFlowEmployeeInfoDTO;
begin

  Result := OriginalDocumentDTO.AuthorDTO;
  
end;

function TIncomingDocumentDTO.GetChargesInfoDTO: TDocumentChargesInfoDTO;
begin

  Result := OriginalDocumentDTO.ChargesInfoDTO;
  
end;

function TIncomingDocumentDTO.GetContent: String;
begin

  Result := OriginalDocumentDTO.Content;
  
end;

function TIncomingDocumentDTO.GetCreationDate: TDateTime;
begin

  Result := OriginalDocumentDTO.CreationDate;
  
end;

function TIncomingDocumentDTO.GetCurrentWorkCycleStageName: String;
begin

  Result := inherited GetCurrentWorkCycleStageName;
  
end;

function TIncomingDocumentDTO.GetCurrentWorkCycleStageNumber: Integer;
begin

  Result := inherited GetCurrentWorkCycleStageNumber;
  
end;

function TIncomingDocumentDTO.GetDocumentDate: Variant;
begin

  Result := OriginalDocumentDTO.DocumentDate;

end;

function TIncomingDocumentDTO.GetFullName: String;
begin

  Result := OriginalDocumentDTO.FullName;
  
end;

function TIncomingDocumentDTO.GetId: Variant;
begin

  Result := inherited GetId;
  
end;

function TIncomingDocumentDTO.GetIsSelfRegistered: Variant;
begin

  Result := OriginalDocumentDTO.IsSelfRegistered;
  
end;

function TIncomingDocumentDTO.GetKind: String;
begin

  Result := inherited GetKind;
  
end;

function TIncomingDocumentDTO.GetKindId: Variant;
begin

  Result := inherited GetKindId;

end;

function TIncomingDocumentDTO.GetName: String;
begin

  Result := OriginalDocumentDTO.Name;
  
end;

function TIncomingDocumentDTO.GetNote: String;
begin

  Result := OriginalDocumentDTO.Note;
  
end;

function TIncomingDocumentDTO.GetNumber: String;
begin

  Result := OriginalDocumentDTO.Number;

end;

function TIncomingDocumentDTO.GetProductCode: String;
begin

  Result := OriginalDocumentDTO.ProductCode;
  
end;

function TIncomingDocumentDTO.GetResponsibleInfoDTO: TDocumentResponsibleInfoDTO;
begin

  Result := OriginalDocumentDTO.ResponsibleInfoDTO;
  
end;

function TIncomingDocumentDTO.GetSeparatorOfNumberParts: String;
begin

  Result := OriginalDocumentDTO.SeparatorOfNumberParts;
  
end;

function TIncomingDocumentDTO.GetSigningsInfoDTO: TDocumentSigningsInfoDTO;
begin

  Result := OriginalDocumentDTO.SigningsInfoDTO;
  
end;

procedure TIncomingDocumentDTO.SetApprovingsInfoDTO(
  const Value: TDocumentApprovingsInfoDTO);
begin

  OriginalDocumentDTO.ApprovingsInfoDTO := Value;
  
end;

procedure TIncomingDocumentDTO.SetAuthorDTO(
  const Value: TDocumentFlowEmployeeInfoDTO);
begin

  OriginalDocumentDTO.AuthorDTO := Value;
  
end;

procedure TIncomingDocumentDTO.SetChargesInfoDTO(
  const Value: TDocumentChargesInfoDTO);
begin

  OriginalDocumentDTO.ChargesInfoDTO := Value;
  
end;

procedure TIncomingDocumentDTO.SetContent(const Value: String);
begin

  OriginalDocumentDTO.Content := Value;
  
end;

procedure TIncomingDocumentDTO.SetCreationDate(const Value: TDateTime);
begin

  OriginalDocumentDTO.CreationDate := Value;
  
end;

procedure TIncomingDocumentDTO.SetCurrentWorkCycleStageName(
  const Value: String);
begin

  inherited;
  
end;

procedure TIncomingDocumentDTO.SetCurrentWorkCycleStageNumber(
  const Value: Integer);
begin

  inherited;
  
end;

procedure TIncomingDocumentDTO.SetDocumentDate(const Value: Variant);
begin

  OriginalDocumentDTO.DocumentDate := Value;
  
end;

procedure TIncomingDocumentDTO.SetFullName(const Value: String);
begin

  OriginalDocumentDTO.FullName := Value;

end;

procedure TIncomingDocumentDTO.SetId(const Value: Variant);
begin

  inherited;
  
end;

procedure TIncomingDocumentDTO.SetIsSelfRegistered(const Value: Variant);
begin

  OriginalDocumentDTO.IsSelfRegistered := Value;

end;

procedure TIncomingDocumentDTO.SetKind(const Value: String);
begin

  inherited;

end;

procedure TIncomingDocumentDTO.SetKindId(const Value: Variant);
begin

  inherited;

end;

procedure TIncomingDocumentDTO.SetName(const Value: String);
begin

  OriginalDocumentDTO.Name := Value;
  
end;

procedure TIncomingDocumentDTO.SetNote(const Value: String);
begin

  OriginalDocumentDTO.Note := Value;
  
end;

procedure TIncomingDocumentDTO.SetNumber(const Value: String);
begin

  OriginalDocumentDTO.Number := Value;
  
end;

procedure TIncomingDocumentDTO.SetOriginalDocumentDTO(
  const Value: TDocumentDTO);
begin

  FOriginalDocumentDTO := Value;
  FFreeOriginalDocumentDTO := Value;
  
end;

procedure TIncomingDocumentDTO.SetProductCode(const Value: String);
begin

  OriginalDocumentDTO.ProductCode := Value;

end;

procedure TIncomingDocumentDTO.SetResponsibleInfoDTO(
  const Value: TDocumentResponsibleInfoDTO);
begin

  OriginalDocumentDTO.ResponsibleInfoDTO := ResponsibleInfoDTO;
  
end;

procedure TIncomingDocumentDTO.SetSeparatorOfNumberParts(const Value: String);
begin

  OriginalDocumentDTO.SeparatorOfNumberParts := Value;
  
end;

procedure TIncomingDocumentDTO.SetSigningsInfoDTO(
  const Value: TDocumentSigningsInfoDTO);
begin

  OriginalDocumentDTO.SigningsInfoDTO := Value;
  
end;

{ TIncomingDocumentFullInfoDTO }

function TIncomingDocumentFullInfoDTO.GetIncomingDocumentDTO: TIncomingDocumentDTO;
begin

  Result := TIncomingDocumentDTO(inherited DocumentDTO);

end;

procedure TIncomingDocumentFullInfoDTO.SetIncomingDocumentDTO(
  const Value: TIncomingDocumentDTO);
begin

  inherited DocumentDTO := Value;

end;

end.

