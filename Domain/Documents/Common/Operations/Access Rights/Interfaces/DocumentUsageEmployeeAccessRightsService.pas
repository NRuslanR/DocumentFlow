unit DocumentUsageEmployeeAccessRightsService;

interface

uses

  DocumentUsageEmployeeAccessRightsInfo,
  DomainObjectValueUnit,
  IDocumentUnit,
  Employee,
  DomainException,
  DocumentKind,
  SysUtils,
  Classes;

type


  TDocumentUsageEmployeeAccessRightsServiceException =
    class (TDomainException)

    end;
    
  IDocumentUsageEmployeeAccessRightsService = interface
    ['{C60B56A7-CAA3-4BA2-86E0-C04143474644}']
    
    function GetDocumentUsageAccessRightsInfoForEmployee(
      Document: IDocument;
      Employee: TEmployee
    ): TDocumentUsageEmployeeAccessRightsInfo;
    
    function EnsureThatEmployeeHasDocumentUsageAccessRights(
      Document: IDocument;
      Employee: TEmployee
    ): TDocumentUsageEmployeeAccessRightsInfo;

    function EnsureThatEmployeeHasRelatedDocumentUsageAccessRights(
      SourceDocument: IDocument;
      RelatedDocument: IDocument;
      RelatedDocumentKind: TDocumentKind;
      Employee: TEmployee
    ): TDocumentUsageEmployeeAccessRightsInfo;

  end;

  IIncomingDocumentUsageEmployeeAccessRightsService =
    interface (IDocumentUsageEmployeeAccessRightsService)
      ['{869CA52E-26D0-4A05-9974-B0940248AE3E}']

    end;
    
implementation

end.
