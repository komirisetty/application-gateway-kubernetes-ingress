/*
Copyright The Kubernetes Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// Code generated by client-gen. DO NOT EDIT.

package fake

import (
	v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	labels "k8s.io/apimachinery/pkg/labels"
	schema "k8s.io/apimachinery/pkg/runtime/schema"
	types "k8s.io/apimachinery/pkg/types"
	watch "k8s.io/apimachinery/pkg/watch"
	testing "k8s.io/client-go/testing"

	azurebackendpoolv1 "github.com/Azure/application-gateway-kubernetes-ingress/pkg/apis/azurebackendpool/v1"
)

// FakeAzureBackendPools implements AzureBackendPoolInterface
type FakeAzureBackendPools struct {
	Fake *FakeAzurebackendpoolsV1
}

var azurebackendpoolsResource = schema.GroupVersionResource{Group: "azurebackendpools.appgw.ingress.azure.io", Version: "v1", Resource: "azurebackendpools"}

var azurebackendpoolsKind = schema.GroupVersionKind{Group: "azurebackendpools.appgw.ingress.azure.io", Version: "v1", Kind: "AzureBackendPool"}

// Get takes name of the azureBackendPool, and returns the corresponding azureBackendPool object, and an error if there is any.
func (c *FakeAzureBackendPools) Get(name string, options v1.GetOptions) (result *azurebackendpoolv1.AzureBackendPool, err error) {
	obj, err := c.Fake.
		Invokes(testing.NewRootGetAction(azurebackendpoolsResource, name), &azurebackendpoolv1.AzureBackendPool{})
	if obj == nil {
		return nil, err
	}
	return obj.(*azurebackendpoolv1.AzureBackendPool), err
}

// List takes label and field selectors, and returns the list of AzureBackendPools that match those selectors.
func (c *FakeAzureBackendPools) List(opts v1.ListOptions) (result *azurebackendpoolv1.AzureBackendPoolList, err error) {
	obj, err := c.Fake.
		Invokes(testing.NewRootListAction(azurebackendpoolsResource, azurebackendpoolsKind, opts), &azurebackendpoolv1.AzureBackendPoolList{})
	if obj == nil {
		return nil, err
	}

	label, _, _ := testing.ExtractFromListOptions(opts)
	if label == nil {
		label = labels.Everything()
	}
	list := &azurebackendpoolv1.AzureBackendPoolList{ListMeta: obj.(*azurebackendpoolv1.AzureBackendPoolList).ListMeta}
	for _, item := range obj.(*azurebackendpoolv1.AzureBackendPoolList).Items {
		if label.Matches(labels.Set(item.Labels)) {
			list.Items = append(list.Items, item)
		}
	}
	return list, err
}

// Watch returns a watch.Interface that watches the requested azureBackendPools.
func (c *FakeAzureBackendPools) Watch(opts v1.ListOptions) (watch.Interface, error) {
	return c.Fake.
		InvokesWatch(testing.NewRootWatchAction(azurebackendpoolsResource, opts))
}

// Create takes the representation of a azureBackendPool and creates it.  Returns the server's representation of the azureBackendPool, and an error, if there is any.
func (c *FakeAzureBackendPools) Create(azureBackendPool *azurebackendpoolv1.AzureBackendPool) (result *azurebackendpoolv1.AzureBackendPool, err error) {
	obj, err := c.Fake.
		Invokes(testing.NewRootCreateAction(azurebackendpoolsResource, azureBackendPool), &azurebackendpoolv1.AzureBackendPool{})
	if obj == nil {
		return nil, err
	}
	return obj.(*azurebackendpoolv1.AzureBackendPool), err
}

// Update takes the representation of a azureBackendPool and updates it. Returns the server's representation of the azureBackendPool, and an error, if there is any.
func (c *FakeAzureBackendPools) Update(azureBackendPool *azurebackendpoolv1.AzureBackendPool) (result *azurebackendpoolv1.AzureBackendPool, err error) {
	obj, err := c.Fake.
		Invokes(testing.NewRootUpdateAction(azurebackendpoolsResource, azureBackendPool), &azurebackendpoolv1.AzureBackendPool{})
	if obj == nil {
		return nil, err
	}
	return obj.(*azurebackendpoolv1.AzureBackendPool), err
}

// Delete takes name of the azureBackendPool and deletes it. Returns an error if one occurs.
func (c *FakeAzureBackendPools) Delete(name string, options *v1.DeleteOptions) error {
	_, err := c.Fake.
		Invokes(testing.NewRootDeleteAction(azurebackendpoolsResource, name), &azurebackendpoolv1.AzureBackendPool{})
	return err
}

// DeleteCollection deletes a collection of objects.
func (c *FakeAzureBackendPools) DeleteCollection(options *v1.DeleteOptions, listOptions v1.ListOptions) error {
	action := testing.NewRootDeleteCollectionAction(azurebackendpoolsResource, listOptions)

	_, err := c.Fake.Invokes(action, &azurebackendpoolv1.AzureBackendPoolList{})
	return err
}

// Patch applies the patch and returns the patched azureBackendPool.
func (c *FakeAzureBackendPools) Patch(name string, pt types.PatchType, data []byte, subresources ...string) (result *azurebackendpoolv1.AzureBackendPool, err error) {
	obj, err := c.Fake.
		Invokes(testing.NewRootPatchSubresourceAction(azurebackendpoolsResource, name, pt, data, subresources...), &azurebackendpoolv1.AzureBackendPool{})
	if obj == nil {
		return nil, err
	}
	return obj.(*azurebackendpoolv1.AzureBackendPool), err
}