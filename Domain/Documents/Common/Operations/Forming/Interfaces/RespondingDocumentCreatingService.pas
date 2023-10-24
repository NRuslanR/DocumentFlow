unit RespondingDocumentCreatingService;

interface

uses

  DocumentUsageEmployeeAccessRightsInfo,
  IDomainObjectBaseUnit,
  DomainObjectValueUnit,
  IDocumentUnit,
  DocumentRelationsUnit,
  DomainException,
  IGetSelfUnit,
  Employee,
  Document;

type

  TRespondingDocumentCreatingServiceException = class (TDomainException)

  end;

  TRespondingDocumentCreatingResult = class (TDomainObjectValue)

    strict private

      FRespondingDocument: IDocument;

      FRespondingDocumentRelations: TDocumentRelations;
      FFreeRespondingDocumentRelations: IDomainObjectBase;

      FRespondingDocumentAccessRights: TDocumentUsageEmployeeAccessRightsInfo;
      FFreeRespondingDocumentAccessRights: IDomainObjectBase;
      
    public

      constructor Create(
        RespondingDocument: IDocument;
        RespondingDocumentRelations: TDocumentRelations;
        RespondingDocumentAccessRights: TDocumentUsageEmployeeAccessRightsInfo
      );

      property RespondingDocument: IDocument read FRespondingDocument;

      property RespondingDocumentRelations: TDocumentRelations
      read FRespondingDocumentRelations;

      property RespondingDocumentAccessRights: TDocumentUsageEmployeeAccessRightsInfo
      read FRespondingDocumentAccessRights;

  end;

  IRespondingDocumentCreatingService = interface (IGetSelf)
    ['{E05B6CD4-3390-457D-ADB6-08250848CB70}']
    
    function CreateRespondingDocumentFor(
      const SourceDocument: IDocument;
      const RequestingEmployee: TEmployee
    ): TRespondingDocumentCreatingResult;

  end;

implementation

{ TRespondingDocumentCreatingResult }

constructor TRespondingDocumentCreatingResult.Create(
  RespondingDocument: IDocument;
  RespondingDocumentRelations: TDocumentRelations;
  RespondingDocumentAccessRights: TDocumentUsageEmployeeAccessRightsInfo
);
begin

  inherited Create;

  FRespondingDocument := RespondingDocument;

  FRespondingDocumentRelations := RespondingDocumentRelations;
  FFreeRespondingDocumentRelations := FRespondingDocumentRelations;

  FRespondingDocumentAccessRights := RespondingDocumentAccessRights;
  FFreeRespondingDocumentAccessRights := FRespondingDocumentAccessRights;
  
end;

end.
