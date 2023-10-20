unit ChangedDocumentInfoDTO;

interface

uses

  DocumentResponsibleInfoDTO,
  DocumentFullInfoDTO,
  DocumentChargeSheetsInfoDTO,
  SysUtils,
  Classes;

type

  TDocumentChargesChangesInfoDTO = class

    public

      AddedDocumentChargesInfoDTO: TDocumentChargesInfoDTO;
      ChangedDocumentChargesInfoDTO: TDocumentChargesInfoDTO;
      RemovedDocumentChargesInfoDTO: TDocumentChargesInfoDTO;

      destructor Destroy; override;

  end;

  TDocumentApprovingsChangesInfoDTO = class (TDocumentApprovingsInfoDTO)

    
  end;

  TChangedDocumentDTO = class

    public

      Id: Variant;
      BaseDocumentId: Variant;
      Number: String;
      Name: String;
      Content: String;
      CreationDate: TDateTime;
      DocumentDate: Variant;
      Note: String;
      IsSelfRegistered: Boolean;
      ProductCode: Variant;

      ApprovingsInfoDTO: TDocumentApprovingsInfoDTO;
      ChargesChangesInfoDTO: TDocumentChargesChangesInfoDTO;
      SigningsInfoDTO: TDocumentSigningsInfoDTO;
      ResponsibleInfoDTO: TDocumentResponsibleInfoDTO;

      CurrentWorkCycleStageNumber: Integer;
      CurrentWorkCycleStageName: String;

      constructor Create; virtual;
      
      destructor Destroy; override;

  end;

  TChangedDocumentInfoDTO = class

    public

      ChangedDocumentDTO: TChangedDocumentDTO;
      ChangedDocumentFilesInfoDTO: TDocumentFilesInfoDTO;
      ChangedDocumentRelationsInfoDTO: TDocumentRelationsInfoDTO;

      destructor Destroy; override;
      
  end;
  
implementation

uses

  Variants;

{ TDocumentChargesChangesInfoDTO }

destructor TDocumentChargesChangesInfoDTO.Destroy;
begin

  FreeAndNil(AddedDocumentChargesInfoDTO);
  FreeAndNil(ChangedDocumentChargesInfoDTO);
  FreeAndNil(RemovedDocumentChargesInfoDTO);
  
  inherited;

end;

{ TChangedDocumentInfoDTO }

destructor TChangedDocumentInfoDTO.Destroy;
begin

  FreeAndNil(ChangedDocumentDTO);
  FreeAndNil(ChangedDocumentFilesInfoDTO);
  FreeAndNil(ChangedDocumentRelationsInfoDTO);
  
  inherited;

end;

{ TChangedDocumentDTO }

constructor TChangedDocumentDTO.Create;
begin

  inherited;

  Id := Null;
  BaseDocumentId := Null;
  DocumentDate := Null;
  
end;

destructor TChangedDocumentDTO.Destroy;
begin

  FreeAndNil(SigningsInfoDTO);
  FreeAndNil(ApprovingsInfoDTO);
  FreeAndNil(ResponsibleInfoDTO);
  FreeAndNil(ChargesChangesInfoDTO);
  
  inherited;

end;

end.
