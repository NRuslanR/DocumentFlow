unit StandardIncomingDocumentUsageEmployeeAccessRightsService;

interface

uses

  DocumentUsageEmployeeAccessRightsService,
  DocumentUsageEmployeeAccessRightsInfo,
  StandardDocumentUsageEmployeeAccessRightsService,
  IDocumentUnit,
  Document,
  IncomingDocument,
  DocumentFullNameCompilationService,
  DocumentChargeSheetFinder,
  DocumentChargeSheet,
  IDocumentChargeSheetUnit,
  EmployeeFinder,
  DocumentRelationsUnit,
  DocumentRelationsFinder,
  Employee,
  SysUtils,
  Classes;

type

  TStandardIncomingDocumentUsageEmployeeAccessRightsService =
    class (
      TStandardDocumentUsageEmployeeAccessRightsService,
      IIncomingDocumentUsageEmployeeAccessRightsService
    )

      protected

        function IsDocumentCanBeViewedByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; override;

        function IsDocumentCanBeRemovedByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; override;

        function IsDocumentCanBeSignedByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; override;

        function IsDocumentCanBeMarkedAsSigned(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; override;

        function IsDocumentCanBeRejectedFromSigningByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; override;

        function IsDocumentCanBePerformedByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; override;

        function IsDocumentCanBeSentToSigningByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; override;

        function IsDocumentCanBeSentToApprovingByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; override;

        function IsDocumentCanBeSentToPerformingByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; override;

        function IsDocumentCanBeChangedByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; override;

        function IsDocumentCanBeMarkedAsSelfRegistered(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; override;

        function IsDocumentApproverListCanBeChangedByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; override;

        function IsDocumentCanBeApprovedByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; override;

        function IsDocumentCanBeRejectedFromApprovingByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; override;

        function IsDocumentApprovingCanBeCompletedByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; override;

      protected

        function GetSourceDocumentRelationsForGettingRelatedDocumentUsageAccessRights(
          const SourceDocument: TDocument
        ): TDocumentRelations; override;

    end;

implementation

uses

  AuxDebugFunctionsUnit;

{ TStandardIncomingDocumentUsageEmployeeAccessRightsService }

function TStandardIncomingDocumentUsageEmployeeAccessRightsService.
  GetSourceDocumentRelationsForGettingRelatedDocumentUsageAccessRights(
    const SourceDocument: TDocument
  ): TDocumentRelations;
begin

  if not (SourceDocument is TIncomingDocument) then begin

    Raise TDocumentUsageEmployeeAccessRightsServiceException.Create(
      'Исходный документ имел не входящий тип ' +
      'во время получения данных о связных документах'
    );

  end;

  Result :=
    FDocumentRelationsFinder.FindRelationsForDocument(
      TIncomingDocument(SourceDocument).OriginalDocument
    );

end;

function TStandardIncomingDocumentUsageEmployeeAccessRightsService.
  IsDocumentApproverListCanBeChangedByEmployee(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result := False;
  
end;

function TStandardIncomingDocumentUsageEmployeeAccessRightsService.IsDocumentApprovingCanBeCompletedByEmployee(
  Document: TDocument; Employee: TEmployee): Boolean;
begin

  Result := False;
  
end;

function TStandardIncomingDocumentUsageEmployeeAccessRightsService.
  IsDocumentCanBeApprovedByEmployee(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result := False;

end;

function TStandardIncomingDocumentUsageEmployeeAccessRightsService.
  IsDocumentCanBeChangedByEmployee(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result := False;
  
end;

function TStandardIncomingDocumentUsageEmployeeAccessRightsService.
  IsDocumentCanBeMarkedAsSelfRegistered(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result := False;

end;

function TStandardIncomingDocumentUsageEmployeeAccessRightsService.
  IsDocumentCanBeMarkedAsSigned(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result := False;
  
end;

function TStandardIncomingDocumentUsageEmployeeAccessRightsService.
  IsDocumentCanBePerformedByEmployee(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result := False;
  
end;

function TStandardIncomingDocumentUsageEmployeeAccessRightsService.
  IsDocumentCanBeRejectedFromApprovingByEmployee(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result := False;
  
end;

function TStandardIncomingDocumentUsageEmployeeAccessRightsService.
  IsDocumentCanBeRejectedFromSigningByEmployee(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result := False;

end;

function TStandardIncomingDocumentUsageEmployeeAccessRightsService.IsDocumentCanBeRemovedByEmployee(
  Document: TDocument; Employee: TEmployee): Boolean;
begin

  Result := False;
  
end;

function TStandardIncomingDocumentUsageEmployeeAccessRightsService.
  IsDocumentCanBeSentToApprovingByEmployee(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result := False;
  
end;

function TStandardIncomingDocumentUsageEmployeeAccessRightsService.
  IsDocumentCanBeSentToPerformingByEmployee(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result := False;
  
end;

function TStandardIncomingDocumentUsageEmployeeAccessRightsService.
  IsDocumentCanBeSentToSigningByEmployee(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result := False;
  
end;

function TStandardIncomingDocumentUsageEmployeeAccessRightsService.
  IsDocumentCanBeSignedByEmployee(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result := False;
  
end;

function TStandardIncomingDocumentUsageEmployeeAccessRightsService.
  IsDocumentCanBeViewedByEmployee(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result := False;

end;

end.
