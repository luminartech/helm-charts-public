<!--- app-name: Apache -->

# EC2 AWS Resources Chart for Crossplane AWS Provider

## TL;DR

## Introduction

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Using the Chart

## Parameters

### AWS resources

| Name                                       | Description         | Value |
| ------------------------------------------ | ------------------- | ----- |
| `AMI`                                      | resource parameters | `{}`  |
| `AMICopy`                                  | resource parameters | `{}`  |
| `AMILaunchPermission`                      | resource parameters | `{}`  |
| `AvailabilityZoneGroup`                    | resource parameters | `{}`  |
| `CapacityReservation`                      | resource parameters | `{}`  |
| `CarrierGateway`                           | resource parameters | `{}`  |
| `CustomerGateway`                          | resource parameters | `{}`  |
| `DefaultNetworkACL`                        | resource parameters | `{}`  |
| `DefaultRouteTable`                        | resource parameters | `{}`  |
| `DefaultSecurityGroup`                     | resource parameters | `{}`  |
| `DefaultSubnet`                            | resource parameters | `{}`  |
| `DefaultVPC`                               | resource parameters | `{}`  |
| `DefaultVPCDHCPOptions`                    | resource parameters | `{}`  |
| `EBSDefaultKMSKey`                         | resource parameters | `{}`  |
| `EBSEncryptionByDefault`                   | resource parameters | `{}`  |
| `EBSSnapshot`                              | resource parameters | `{}`  |
| `EBSSnapshotCopy`                          | resource parameters | `{}`  |
| `EBSSnapshotImport`                        | resource parameters | `{}`  |
| `EBSVolume`                                | resource parameters | `{}`  |
| `EIP`                                      | resource parameters | `{}`  |
| `EIPAssociation`                           | resource parameters | `{}`  |
| `EgressOnlyInternetGateway`                | resource parameters | `{}`  |
| `FlowLog`                                  | resource parameters | `{}`  |
| `Host`                                     | resource parameters | `{}`  |
| `Instance`                                 | resource parameters | `{}`  |
| `InstanceState`                            | resource parameters | `{}`  |
| `InternetGateway`                          | resource parameters | `{}`  |
| `KeyPair`                                  | resource parameters | `{}`  |
| `LaunchTemplate`                           | resource parameters | `{}`  |
| `MainRouteTableAssociation`                | resource parameters | `{}`  |
| `ManagedPrefixList`                        | resource parameters | `{}`  |
| `ManagedPrefixListEntry`                   | resource parameters | `{}`  |
| `NATGateway`                               | resource parameters | `{}`  |
| `NetworkACL`                               | resource parameters | `{}`  |
| `NetworkACLRule`                           | resource parameters | `{}`  |
| `NetworkInsightsAnalysis`                  | resource parameters | `{}`  |
| `NetworkInsightsPath`                      | resource parameters | `{}`  |
| `NetworkInterface`                         | resource parameters | `{}`  |
| `NetworkInterfaceAttachment`               | resource parameters | `{}`  |
| `NetworkInterfaceSgAttachment`             | resource parameters | `{}`  |
| `PlacementGroup`                           | resource parameters | `{}`  |
| `Route`                                    | resource parameters | `{}`  |
| `RouteTable`                               | resource parameters | `{}`  |
| `RouteTableAssociation`                    | resource parameters | `{}`  |
| `SecurityGroup`                            | resource parameters | `{}`  |
| `SecurityGroupRule`                        | resource parameters | `{}`  |
| `SerialConsoleAccess`                      | resource parameters | `{}`  |
| `SnapshotCreateVolumePermission`           | resource parameters | `{}`  |
| `SpotDatafeedSubscription`                 | resource parameters | `{}`  |
| `SpotFleetRequest`                         | resource parameters | `{}`  |
| `SpotInstanceRequest`                      | resource parameters | `{}`  |
| `Subnet`                                   | resource parameters | `{}`  |
| `SubnetCidrReservation`                    | resource parameters | `{}`  |
| `Tag`                                      | resource parameters | `{}`  |
| `TrafficMirrorFilter`                      | resource parameters | `{}`  |
| `TrafficMirrorFilterRule`                  | resource parameters | `{}`  |
| `TransitGateway`                           | resource parameters | `{}`  |
| `TransitGatewayConnect`                    | resource parameters | `{}`  |
| `TransitGatewayConnectPeer`                | resource parameters | `{}`  |
| `TransitGatewayMulticastDomain`            | resource parameters | `{}`  |
| `TransitGatewayMulticastDomainAssociation` | resource parameters | `{}`  |
| `TransitGatewayMulticastGroupMember`       | resource parameters | `{}`  |
| `TransitGatewayMulticastGroupSource`       | resource parameters | `{}`  |
| `TransitGatewayPeeringAttachment`          | resource parameters | `{}`  |
| `TransitGatewayPeeringAttachmentAccepter`  | resource parameters | `{}`  |
| `TransitGatewayPolicyTable`                | resource parameters | `{}`  |
| `TransitGatewayPrefixListReference`        | resource parameters | `{}`  |
| `TransitGatewayRoute`                      | resource parameters | `{}`  |
| `TransitGatewayRouteTable`                 | resource parameters | `{}`  |
| `TransitGatewayRouteTableAssociation`      | resource parameters | `{}`  |
| `TransitGatewayRouteTablePropagation`      | resource parameters | `{}`  |
| `TransitGatewayVPCAttachment`              | resource parameters | `{}`  |
| `TransitGatewayVPCAttachmentAccepter`      | resource parameters | `{}`  |
| `VPC`                                      | resource parameters | `{}`  |
| `VPCDHCPOptions`                           | resource parameters | `{}`  |
| `VPCDHCPOptionsAssociation`                | resource parameters | `{}`  |
| `VPCEndpoint`                              | resource parameters | `{}`  |
| `VPCEndpointConnectionNotification`        | resource parameters | `{}`  |
| `VPCEndpointRouteTableAssociation`         | resource parameters | `{}`  |
| `VPCEndpointSecurityGroupAssociation`      | resource parameters | `{}`  |
| `VPCEndpointService`                       | resource parameters | `{}`  |
| `VPCEndpointServiceAllowedPrincipal`       | resource parameters | `{}`  |
| `VPCEndpointSubnetAssociation`             | resource parameters | `{}`  |
| `VPCIPv4CidrBlockAssociation`              | resource parameters | `{}`  |
| `VPCIpam`                                  | resource parameters | `{}`  |
| `VPCIpamPool`                              | resource parameters | `{}`  |
| `VPCIpamPoolCidr`                          | resource parameters | `{}`  |
| `VPCIpamPoolCidrAllocation`                | resource parameters | `{}`  |
| `VPCIpamScope`                             | resource parameters | `{}`  |
| `VPCPeeringConnection`                     | resource parameters | `{}`  |
| `VPCPeeringConnectionAccepter`             | resource parameters | `{}`  |
| `VPCPeeringConnectionOptions`              | resource parameters | `{}`  |
| `VPNConnection`                            | resource parameters | `{}`  |
| `VPNConnectionRoute`                       | resource parameters | `{}`  |
| `VPNGateway`                               | resource parameters | `{}`  |
| `VPNGatewayAttachment`                     | resource parameters | `{}`  |
| `VPNGatewayRoutePropagation`               | resource parameters | `{}`  |
| `VolumeAttachment`                         | resource parameters | `{}`  |


## Configuration and installation details


## Troubleshooting


## Notable changes
